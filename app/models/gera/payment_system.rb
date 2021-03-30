# frozen_string_literal: true

module Gera
  class PaymentSystem < ApplicationRecord
    include ::Archivable
    include Gera::Mathematic
    include Authority::Abilities

    scope :ordered, -> { order :priority }
    scope :enabled, -> { where 'income_enabled>0 or outcome_enabled>0' }
    scope :disabled, -> { where income_enabled: false, outcome_enabled: false }
    scope :available, -> { where is_available: true }

    # TODO: move to kassa-admin
    enum total_computation_method: %i[regular_fee reverse_fee]
    enum transfer_comission_payer: %i[user shop], _prefix: :transfer_comission_payer

    validates :name, presence: true, uniqueness: true
    validates :currency, presence: true

    before_create do
      self.priority = self.class.maximum(:priority).to_i + 1
    end

    after_create :create_exchange_rates

    delegate :iso_code, to: :currency, prefix: true, allow_nil: true

    alias_attribute :archived_at, :deleted_at
    alias_attribute :enable_income, :income_enabled
    alias_attribute :enable_outcome, :outcome_enabled
    alias_attribute :currency_id, :type_cy

    def currency
      return unless currency_id

      Money::Currency.find_by_local_id(currency_id) || raise("No currency found #{currency_id}")
    end

    def currency=(value)
      if value.blank?
        self.currency_id = nil
      elsif value.is_a? Money::Currency
        self.currency_id = value.local_id
      elsif value.to_s.to_i.to_s == value.to_s # local_id
        self.currency_id = (Money::Currency.find_by_local_id(value) || raise("No currency found #{value}")).local_id
      else
        self.currency_iso_code = value
      end
      self.currency
    end

    def currency_iso_code=(value)
      self.currency_id = (Money::Currency.find(value) || raise("No currency found #{value}")).local_id
      currency_iso_code
    end

    def to_s
      name
    end

    # TODO: move to kassa-admin
    def total_with_fee(money)
      calculate_total(money: money, fee: transfer_fee)
    end

    def unverified_total_with_fee(money)
      calculate_total(money: money, fee: unverified_transfer_fee)
    end

    private

    def calculate_total(money:, fee:)
      if fee.computation_method == 'regular_fee'
        calculate_total_using_regular_comission(money, fee.amount)
      elsif fee.computation_method == 'reverse_fee'
        calculate_total_using_reverse_comission(money, fee.amount)
      else
        raise NotImplementedError, "Нет расчета для #{fee.computation_method}"
      end
    end

    def transfer_fee
      OpenStruct.new(
        amount: income_fee,
        computation_method: total_computation_method
      ).freeze
    end

    def unverified_transfer_fee
      OpenStruct.new(
        amount: unverified_income_fee,
        computation_method: total_computation_method
      ).freeze
    end

    DEFAULT_COMMISSION = 10

    def create_exchange_rates
      PaymentSystem.pluck(:id).each do |foreign_id|
        ExchangeRate
          .create_with(commission: DEFAULT_COMMISSION)
          .find_or_create_by(payment_system_from_id: id, payment_system_to_id: foreign_id)

        ExchangeRate
          .create_with(commission: DEFAULT_COMMISSION)
          .find_or_create_by(payment_system_from_id: foreign_id, payment_system_to_id: id)
      end
    end
  end
end
