namespace :shelterluv_exp do
  require 'csv'
  require 'fileutils'

  path = "/tmp/shelterluv/"

  filename = 'animals.csv'

  desc "Export Records to CSV, for Shelterluv"
  task export_upload: :environment do
    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Shelterluv Export Start"

    FileUtils::Verbose.rm_r(path) if Dir.exists?(path)
    FileUtils::Verbose.mkdir(path)

    #dogs = Dog.all
    dogs = Dog.eager_load(:adoptions).where(adoptions: {relation_type: "adopted"}).order(updated_at: :desc).distinct
    CSV.open(path + filename, "wt", force_quotes: "true", col_sep: ",") do |csv|
      dogs.each do |d|
        csv << [
                d.tracking_id.to_s,                                        # Animal ID
                "Dog",                                                     # Species
                d.primary_breed ? d.primary_breed.name : "",               # Primary Breed
                "Transfer In",                                             # Intake Type
                d.intake_dt ? intake_dt : d.created_at.strftime("%F"),     # Intake Date
                d.adoption_date ? "Adoption" : "",                         # Outcome Type
                d.adoption_date ? d.adoption_date : "",                    # Outcome Date
                d.name,                                                    # Animal Name
                d.gender,                                                  # Gender
                d.to_shelterluv_age,                                       # Age Group
                d.shelter.name ? d.shelter.name : "DMS Import",            # Transfer In Partner
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
                d.adoptions.adopter.id,                           # Outcome person id
                d.adoptions.adopter.name,                         # Outcome person name
                d.adoptions.adopter.email,                        # outcome person email
                d.adoption.adopter.phone,                         # outcome person home phone
                "",                                               # outcome person cell phone
                d.adoption.adopter.address2,                      # outcome person unit number
                "todo",                                           # outcome person street number
                "todo",                                                  # outcome person street name
                "todo",                                                  # outcome person street type
                "todo",                                                 # outcome person street direction
                d.adoption.adopter.city,                                                  # outcome person city
                d.adoption.adopter.state,                                     # outcome person sate
                d.adotion.adopter.zip,                                                  # outcome person zip
                "",                                                        # intake subtype
                "",                                                            # outcome subtype
                d.secondary_breed ? d.secondary_breed.name : "",          # secondary breed
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

    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Shelterluv Export Completed"


  end

  private


end
