class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :packs, dependent: :destroy
    has_many :cards, through: :packs
end
