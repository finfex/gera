# frozen_string_literal: true

module Gera
  class DirectionRatesController < Gera::ApplicationController
    authorize_actions_for DirectionRate
    authority_actions last: :read

    # TODO: use params from show
    def last
      exchange_rate = direction_rate.exchange_rate
      dr = Universe.direction_rates_repository.find_direction_rate_by_exchange_rate_id exchange_rate.id

      redirect_to direction_rate_path(dr), flash: { success: "Перекинули на страницу курса от #{I18n.l dr.created_at, format: :long}" }
    end

    def show
      render locals: {
        direction_rate: direction_rate
      }
    end

    def index
      render locals: { snapshot: snapshot }
    end

    private

    def snapshot
      Gera::Universe.direction_rates_repository.snapshot
    rescue Gera::DirectionRatesRepository::NoActualSnapshot
      nil
    end

    def direction_rate
      @direction_rate ||= DirectionRate.find params[:id]
    end
  end
end
