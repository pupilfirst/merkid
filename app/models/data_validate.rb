class DataValidate
  def self.run(model, schema)

    schema.each do |k, v|
      if v.blank?
        model.errors[:base] << ""
      end
    end
  end
end
