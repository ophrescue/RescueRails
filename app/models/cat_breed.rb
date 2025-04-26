#    Copyright 2019 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# == Schema Information
#
# Table name: cat_breeds
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatBreed < ApplicationRecord
  has_many :primary_breed_cats, class_name: 'Cat', foreign_key: 'primary_breed_id'
  has_many :secondary_breed_cats, class_name: 'Cat', foreign_key: 'secondary_breed_id'

  SHELTERLUV_BREED = {
    "Chinchilla"                                => "Unknown",
    "Cornish Rex"                               => "Cornish Rex",
    "Cymric"                                    => "Cymric",
    "Devon Rex"                                 => "Devon Rex",
    "Dilute Calico"                             => "Unknown",
    "Dilute Tortoiseshell"                      => "Unknown",
    "Domestic Long Hair"                        => "Domestic Longhair",
    "Domestic Medium Hair"                      => "Domestic Medium Hair",
    "Domestic Short Hair"                       => "Domestic Shorthair",
    "Egyptian Mau"                              => "Egyptian Mau",
    "Exotic Shorthair"                          => "Exotic Shorthair",
    "Extra-Toes Cat - Hemingway Polydactyl"     => "Extra-Toes Cat (Hemingway Polydactyl)",
    "Havana"                                    => "Havana Brown",
    "Himalayan"                                 => "Himalayan",
    "Japanese Bobtail"                          => "Japanese Bobtail",
    "Javanese"                                  => "Javanese",
    "Korat"                                     => "Korat",
    "LaPerm"                                    => "Laperm",
    "Maine Coon"                                => "Maine Coon",
    "Manx"                                      => "Manx",
    "Munchkin"                                  => "Munchkin",
    "Nebelung"                                  => "Nebelung",
    "Norwegian Forest Cat"                      => "Norwegian Forest Cat",
    "Ocicat"                                    => "Ocicat",
    "Oriental Long Hair"                        => "Oriental Long Hair",
    "Oriental Short Hair"                       => "Oriental Short Hair",
    "Oriental Tabby"                            => "Unknown",
    "Persian"                                   => "Persian",
    "Pixiebob"                                  => "Pixie-Bob",
    "Ragamuffin"                                => "Ragamuffin",
    "Ragdoll"                                   => "Ragdoll",
    "Russian Blue"                              => "Russian Blue",
    "Scottish Fold"                             => "Scottish Fold",
    "Selkirk Rex"                               => "Selkirk Rex",
    "Siamese"                                   => "Siamese",
    "Siberian"                                  => "Siberian",
    "Silver"                                    => "Unknown",
    "Singapura"                                 => "Singapura",
    "Snowshoe"                                  => "Snowshoe",
    "Somali"                                    => "Somali",
    "Sphynx - Hairless Cat"                     => "Sphynx",
    "Tabby"                                     => "Unknown",
    "Tiger"                                     => "Unknown",
    "Tonkinese"                                 => "Tonkinese",
    "Torbie"                                    => "Unknown",
    "Tortoiseshell"                             => "Unknown",
    "Turkish Angora"                            => "Turkish Angora",
    "Turkish Van"                               => "Turkish Van",
    "Tuxedo"                                    => "Unknown",
    "York Chocolate"                            => "Unknown",
    "Abyssinian"                                => "Abyssinian",
    "American Bobtail"                          => "American Bobtail",
    "American Curl"                             => "American Curl",
    "American Shorthair"                        => "American Shorthair",
    "American Wirehair"                         => "American Wirehair",
    "Applehead Siamese"                         => "Siamese",
    "Balinese"                                  => "Balinese",
    "Bengal"                                    => "Bengal",
    "Birman"                                    => "Birman",
    "Bombay"                                    => "Bombay",
    "British Shorthair"                         => "British Shorthair",
    "Burmese"                                   => "Burmese",
    "Burmilla"                                  => "Unknown",
    "Calico"                                    => "Unknown",
    "Canadian Hairless"                         => "Unknown",
    "Chartreux"                                 => "Chartreux",
    "Chausie"                                   => "Unknown"
  }


  def display_name
    name
  end

  def to_shelterluv_breed
    SHELTERLUV_BREED[name]
  end
end
