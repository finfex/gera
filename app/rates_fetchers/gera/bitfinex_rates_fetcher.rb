# frozen_string_literal: true

module Gera
  # Import rates from Bitfinex
  #
  class BitfinexRatesFetcher < BaseRatesFetcher
    include AutoLogger

    SUPPORTED_TICKERS_UPDATE_PERIOD = 1.day

    def update_supported_tickers(force=true)
      return unless force && (rate_source.supported_tickers_updated_at.nil? || rate_source.supported_tickers_updated_at < SUPPORTED_TICKERS_UPDATE_PERIOD.ago)
      supported_tickers = BitfinexFetcher.new.fetch_tickers
      logger.info "Update supported_tickers: #{supported_tickers}"
      rate_source.update! supported_tickers: supported_tickers, supported_tickers_updated_at: Time.zone.now
    end

    private

    def rate_source
      @rate_source ||= RateSourceBitfinex.get!
    end

    # {"mid":"8228.25",
    # "bid":"8228.2",
    # "ask":"8228.3",
    # "last_price":"8228.3",
    # "low":"8055.0",
    # "high":"8313.3",
    # "volume":"13611.826947359996",
    # "timestamp":"1532874580.9087598"}
    def save_rate(ticker, data)
      currency_pair = pair_from_ticker ticker
      logger.info "save_rate #{ticker} #{data}"
      create_external_rates currency_pair, data, sell_price: data['high'], buy_price: data['low']
    end

    def pair_from_ticker(ticker)
      ticker = ticker.to_s
      CurrencyPair.new(
        rate_source.from_ticker(ticker[0, 3]),
        rate_source.from_ticker(ticker[3, 3])
      )
    end

    def load_rates
      update_supported_tickers(false)
      logger.info "load_rates: [#{rate_source.tickers_to_load.join(',')}]"
      rate_source.
        tickers_to_load.
        each_with_object({}) { |ticker, ag| ag[ticker] = BitfinexFetcher.new.fetch_ticker(ticker) }
    end
  end
end
