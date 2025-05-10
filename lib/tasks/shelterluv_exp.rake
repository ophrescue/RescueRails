namespace :shelterluv do
  require 'csv'
  require 'fileutils'

  path = "/tmp/shelterluv/"

  animal_csv = 'animals.csv'
  memo_csv = 'memos.csv'

  desc "Export Records to CSV, for Shelterluv"
  task export: :environment do
    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Shelterluv Export Start"

    FileUtils::Verbose.rm_r(path) if Dir.exists?(path)
    FileUtils::Verbose.mkdir(path)


    subquery = Adoption.where(relation_type: 'adopted').to_sql
    dogs = Dog.joins("LEFT JOIN (#{subquery}) AS adptn ON adptn.dog_id = dogs.id")

    CSV.open(path + animal_csv, "wt", force_quotes: "true", col_sep: ",") do |csv|
      dogs.each do |d|


        if d.adopters.first
          if d.adopters.first.address1.match(/^(\d+)\s+(.+?)\s+(\w+(?:\s+\w+){0,3})$/)
            street_number = Regexp.last_match[1]
            street_name   = Regexp.last_match[2].strip
            street_type   = Regexp.last_match[3].strip
          else
            street_number = ""
            street_name = d.adopters.first.address1
            street_type = ""
          end
        end

        csv << [
                "D" + d.tracking_id.to_s,                                        # Animal ID (add a D in font)
                "Dog",                                                     # Species
                d.primary_breed ? d.primary_breed.to_shelterluv_breed : "Unknown",               # Primary Breed
                "Transfer In",                                             # Intake Type
                process_intake_dt(d.intake_dt, d.adoption_date, d.created_at), # Intake Date
                d.adopters.first && d.adoption_date ? "Adoption" : "",             # Outcome Type
                d.adopters.first && d.adoption_date ? d.adoption_date : "",        # Outcome Date
                d.name,                                                    # Animal Name
                d.gender.present? ? d.gender : "Uknown",                  # Gender
                d.to_shelterluv_age,                                       # Age Group
                d.shelter ? d.shelter.name : "",            # Transfer In Partner
                "",                                                        # Transfer Out Partner
                "IMPORT",                                                  # Intake Person ID
                "DMS Import",                                              # Intake person name
                "",                                                    # Intake person email
                "",                                               # Intake person home phone
                "",                                               # Intake person cell phone
                "",                                               # intake person unit number
                "",                                               # Intake person street number
                "",                                               # Intake person street name
                "",                                               # Intake person street type
                "",                                               # Intake person street direction
                "",                                               # Intake person city
                "",                                               # Intake person state
                "",                                               # Intake person zip code
                d.adopters.first ? d.adopters.first.id : "",                           # Outcome person id
                d.adopters.first ? d.adopters.first.name : "",                         # Outcome person name
                d.adopters.first ? d.adopters.first.email : "",                        # outcome person email
                d.adopters.first ? d.adopters.first.phone : "",                         # outcome person home phone
                "",                                               # outcome person cell phone
                d.adopters.first ? d.adopters.first.address2 : "",      # outcome person unit number
                d.adopters.first ? street_number : "",           # outcome person street number
                d.adopters.first ? street_name : "",           # outcome person street name
                d.adopters.first ? street_type : "",           # outcome person street type
                "",                                                   # outcome person street direction
                d.adopters.first ? d.adopters.first.city : "",         # outcome person city
                d.adopters.first ? d.adopters.first.state : "",            # outcome person sate
                d.adopters.first ? d.adopters.first.zip : "",                # outcome person zip
                "",                                                        # intake subtype
                "",                                                            # outcome subtype
                d.secondary_breed ? d.secondary_breed.to_shelterluv_breed : "",          # secondary breed
                "",                                                        # distinguiishing marks
                d.is_altered ? "Yes" : "No",                             # altered
                d.birth_dt ? d.birth_dt : "",                           # date of birth
                d.status,                                                        # current status
                "",                                                        # location
                "",                                                        # sublocation
                "",                                                        # microchip issue date
                "",                                                        # microchip issuer
                d.microchip,                                                        # microchip number
                "",                                                        # additional previous id
                "",                                                        # found address
                "",                                                        # found zip code
                "",                                                        # asilomar intake status
                ""]                                                        # asilomar outcome status
      end
    end

    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Dog Export Completed, starting Cat Export"

    cat_subquery = CatAdoption.where(relation_type: 'adopted').to_sql
    cats = Cat.joins("LEFT JOIN (#{cat_subquery}) AS adptn ON adptn.cat_id = cats.id")

    CSV.open(path + animal_csv, "at", force_quotes: "true", col_sep: ",") do |csv|
      cats.each do |c|

        if c.adopters.first
          if c.adopters.first.address1.match(/^(\d+)\s+(.+?)\s+(\w+(?:\s+\w+){0,3})$/)
            street_number = Regexp.last_match[1]
            street_name   = Regexp.last_match[2].strip
            street_type   = Regexp.last_match[3].strip
          else
            street_number = ""
            street_name = c.adopters.first.address1
            street_type = ""
          end
        end

        csv << [
                "C" + c.tracking_id.to_s,                                      # Animal ID (add a C in front)
                "Cat",                                                     # Species
                c.primary_breed ? c.primary_breed.to_shelterluv_breed : "Unknown",               # Primary Breed
                "Transfer In",                                             # Intake Type
                process_intake_dt(c.intake_dt, c.adoption_date, c.created_at), # Intake Date
                c.adopters.first && c.adoption_date ? "Adoption" : "",             # Outcome Type
                c.adopters.first && c.adoption_date ? c.adoption_date : "",        # Outcome Date
                c.name,                                                    # Animal Name
                c.gender.present? ? c.gender : "Unknown",                   # Gender
                c.to_shelterluv_age,                                       # Age Group
                c.shelter ? c.shelter.name : "",            # Transfer In Partner
                "",                                                        # Transfer Out Partner
                "IMPORT",                                                  # Intake Person ID
                "DMS Import",                                              # Intake person name
                "",                                                    # Intake person email
                "",                                               # Intake person home phone
                "",                                               # Intake person cell phone
                "",                                               # intake person unit number
                "",                                               # Intake person street number
                "",                                               # Intake person street name
                "",                                               # Intake person street type
                "",                                               # Intake person street direction
                "",                                               # Intake person city
                "",                                               # Intake person state
                "",                                               # Intake person zip code
                c.adopters.first ? c.adopters.first.id : "",                           # Outcome person id
                c.adopters.first ? c.adopters.first.name : "",                         # Outcome person name
                c.adopters.first ? c.adopters.first.email : "",                        # outcome person email
                c.adopters.first ? c.adopters.first.phone : "",                         # outcome person home phone
                "",                                               # outcome person cell phone
                c.adopters.first ? c.adopters.first.address2 : "",      # outcome person unit number
                c.adopters.first ? street_number : "",           # outcome person street number
                c.adopters.first ? street_name : "",           # outcome person street name
                c.adopters.first ? street_type : "",           # outcome person street type
                "",                                                   # outcome person street direction
                c.adopters.first ? c.adopters.first.city : "",         # outcome person city
                c.adopters.first ? c.adopters.first.state : "",            # outcome person sate
                c.adopters.first ? c.adopters.first.zip : "",                # outcome person zip
                "",                                                        # intake subtype
                "",                                                            # outcome subtype
                c.secondary_breed ? c.secondary_breed.to_shelterluv_breed : "",          # secondary breed
                "",                                                        # distinguiishing marks
                c.is_altered ? "Yes" : "No",                             # altered
                c.birth_dt ? c.birth_dt : "",                           # date of birth
                c.status,                                                        # current status
                "",                                                        # location
                "",                                                        # sublocation
                "",                                                        # microchip issue date
                "",                                                        # microchip issuer
                c.microchip,                                                        # microchip number
                "",                                                        # additional previous id
                "",                                                        # found address
                "",                                                        # found zip code
                "",                                                        # asilomar intake status
                ""]                                                        # asilomar outcome status
      end
    end

    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Shelterluv animal Export Completed"

    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Shelterluv Memo Export Start"

    dogs_all = Dog.all

    CSV.open(path + memo_csv, "wt", force_quotes: "true", col_sep: ",") do |csv|
      dogs_all.each do |dd|
        if dd.description.present?
          csv << [dd.created_at.strftime("%F"),     # Date
                  "D"+ dd.tracking_id.to_s,     # Animal ID
                  "Kennel Card/Website",        # Memo Type
                  dd.description ? dd.description.gsub(/\R+/, ' ') : ""                # Memo Content
          ]
        end
      end

      dogs_all.each do |dd|
        if dd.medical_summary.present?
          csv << [dd.created_at.strftime("%F"),     # Date
                  "D"+ dd.tracking_id.to_s,     # Animal ID
                  "Medical",        # Memo Type
                  dd.medical_summary ? dd.medical_summary.gsub(/\R+/, ' ') : ""           # Memo Content
          ]
        end
      end

      dogs_all.each do |dd|
        if dd.behavior_summary.present?
          csv << [dd.created_at.strftime("%F"),     # Date
                  "D"+ dd.tracking_id.to_s,     # Animal ID
                  "Behavior",        # Memo Type
                  dd.behavior_summary ? dd.behavior_summary.gsub(/\R+/, ' ') : ""          # Memo Content
          ]
        end
      end

      dogs_all.each do |dd|
        dd.comments.each do |ddc|
          if ddc.content.present?
            csv << [ddc.created_at.strftime("%F"),     # Date
                    "D"+ dd.tracking_id.to_s,     # Animal ID
                    "Private**",        # Memo Type
                    ddc.content ? ddc.content.gsub(/\R+/, ' ') : " "           # Memo Content
            ]
          end
        end
      end

    end

    cats_all = Cat.all

    CSV.open(path + memo_csv, "at", force_quotes: "true", col_sep: ",") do |csv|
      cats.each do |cc|
        if cc.description.present?
          csv << [cc.created_at.strftime("%F"),     # Date
                  "C"+ cc.tracking_id.to_s,     # Animal ID
                  "Kennel Card/Website",        # Memo Type
                  cc.description ? cc.description.gsub(/\R+/, ' ') : " "                # Memo Content
          ]
        end
      end

      cats_all.each do |cc|
        if cc.medical_summary.present?
          csv << [cc.created_at.strftime("%F"),     # Date
                  "C"+ cc.tracking_id.to_s,     # Animal ID
                  "Medical",        # Memo Type
                  cc.medical_summary ? cc.medical_summary.gsub(/\R+/, ' ') : " "           # Memo Content
          ]
        end
      end

      cats_all.each do |cc|
        if cc.behavior_summary.present?
          csv << [cc.created_at.strftime("%F"),     # Date
                  "C"+ cc.tracking_id.to_s,     # Animal ID
                  "Behavior",        # Memo Type
                  cc.behavior_summary ? cc.behavior_summary.gsub(/\R+/, ' ') : " "           # Memo Content
          ]
        end
      end

      cats_all.each do |cc|
        cc.comments.each do |ccc|
          if ccc.content.present?
            csv << [ccc.created_at.strftime("%F"),     # Date
                    "C"+ cc.tracking_id.to_s,     # Animal ID
                    "Private**",        # Memo Type
                    ccc.content ? ccc.content.gsub(/\R+/, ' ') : " "           # Memo Content
            ]
          end
        end
      end

    end

      puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Shelterluv Export COMPLETE!"
  end

  private

  def process_intake_dt(intake_dt, adoption_date, created_at)
    return created_at unless adoption_date

    if intake_dt.present? && intake_dt < adoption_date
      intake_dt
    else
      adoption_date - 30.days
    end
  end

end
