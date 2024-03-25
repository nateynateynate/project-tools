# frozen_string_literal: true

module GitHub
  module Buckets
    def members
      buckets[:members] || []
    end

    def contractors
      buckets[:contractors] || []
    end

    def external
      buckets[:external] || []
    end

    def students
      buckets[:students] || []
    end

    def unknown
      buckets[:unknown] || []
    end

    def bots
      buckets[:bots] || []
    end

    def all
      to_a
    end

    def all_humans
      all.to_a - bots.to_a
    end

    def all_members
      members.to_a
    end

    def all_external
      all = []
      Maintainers::ALL_EXTERNAL.each do |bucket|
        next unless buckets[bucket]

        all.concat(buckets[bucket].to_a)
      end
      all
    end

    def all_external_percent
      return 0 unless all.any?

      ((all_external.size.to_f / all_humans.size) * 100).to_i
    end

    def percent
      buckets.map do |k, v|
        pc = ((v.size.to_f / all_humans.size) * 100).round(1)
        [k, pc]
      end.to_h
    end

    def self.bucket(username)
      if GitHub::Data.members_data.include?(username.to_s)
        :members
      elsif GitHub::Data.contractors_data.include?(username.to_s)
        :contractors
      elsif GitHub::Data.students_data.include?(username.to_s)
        :students
      elsif GitHub::Data.external_data.include?(username.to_s)
        :external
      elsif GitHub::Data.bots_data.include?(username.to_s)
        :bots
      else
        :unknown
      end
    end

    def [](bucket)
      buckets[bucket]
    end

    def buckets
      raise NotImplementedError, :buckets
    end
  end
end
