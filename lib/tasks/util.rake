namespace :wms do
  namespace :util do
    desc 'Auto run rubocop commiting changes and running tests between cops.'
    task :autocop, [:filter] => :environment do |_, args|
      exit unless Rails.env.development?

      clear_output_directory
      check_git_branch

      offending_cop_list.each_slice(2) do |_, cop|
        next if filtered_out_cop?(cop, args)

        rubocop_run(cop)

        unless files_changed?
          Rails.logger.info 'No files changed, skipping tests.'
          next
        end

        rspec_passed = rspec_run(cop)
        track_error(cop) unless rspec_passed
        git_commit_changes(cop)
      end
    end

    def clear_output_directory
      FileUtils.rm_rf('/tmp/autocop')
    end

    def check_git_branch
      create_git_branch if git_current_branch != git_autocop_branch_name
    end

    def create_git_branch
      `git checkout -b #{git_autocop_branch_name}`
    end

    def git_current_branch
      branch_name = `git symbolic-ref HEAD`
      branch_name.chop.sub('refs/heads/', '')
    end

    def git_autocop_branch_name
      'rubocop-autocop'
    end

    def git_reset_hard
      Rails.logger.info 'Tests failed, resetting files'
      `git reset --hard`
    end

    def git_commit_changes(cop)
      Rails.logger.info "Commiting changes for #{cop}"
      `git commit -a -m 'Autocop cleanup of #{cop} offenses'`
    end

    def offending_cop_list
      Rails.logger.info 'Getting offending cop list'

      output = `rubocop -f o`
      output.split
    end

    def rubocop_run(cop)
      file_name = "/tmp/autocop/rubcop-#{cop.parameterize}"

      Rails.logger.info "Running rubocop, output in #{file_name}"
      `rubocop --only #{cop} -a -o #{file_name}`
    end

    def rspec_run(cop)
      file_name = "/tmp/autocop/rspec-#{cop.parameterize}"

      Rails.logger.info "Running tests, output in #{file_name}"
      tests_passed = system("RAILS_ENV=test rspec --fail-fast --no-profile -f d -o #{file_name}")

      git_reset_hard unless tests_passed

      tests_passed
    end

    def track_error(cop)
      Rails.logger.info "#{cop} caused tests to fail."
    end

    def files_changed?
      output = `git status -s -uno | wc -l`

      output.to_i > 0
    end

    def filtered_out_cop?(cop, args)
      args[:filter].present? && cop !~ /#{args[:filter]}/i
    end
  end
end

