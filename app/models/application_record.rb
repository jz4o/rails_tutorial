# 基幹モデル
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
