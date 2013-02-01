# -*- coding: utf-8 -*-
module Bow
  module Room

    # 채팅 매니져
    # 싱글톤
    class KennelManager
      include Singleton

      def initialize
        @kennel_list = []
        @kennel_id = 0
      end

      def make_kennel_id
        @kennel_id = @kennel_id + 1
      end

      def create_kennel params
        k = Kennel.new params
        k.enter params[:user]
        @kennel_list << k
        k
      end

      def kennel kennel_id
        k = nil
        kennel_list.each do |kennel|
          k = kennel if kennel.id == kennel_id
        end
        k
      end

    end

    # 채팅방 객체
    class Kennel
      attr_reader :id, :positive_label, :negative_label
      attr_accessor :title


      def initialize params
        @id = KennelManager.instance.make_kennel_id
        @title = params[:title]
        @positive_label = params[:positive_label]
        @negative_label = params[:negative_label]
        @users = []
      end

      def enter user
        @users << user
      end

      def exit user
        @users.delete user
      end

    end
  end
end
