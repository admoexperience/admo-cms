describe AdmoAccount do
  describe '#push_update_pods' do
    it 'calls #push_update_pods on each of its units' do
      account = create(:admo_account)
      account.admo_units << create(:admo_unit)
      account.admo_units << create(:admo_unit)

      account.admo_units.each do |unit|
        unit.should_receive :push_update_pods
      end

      account.push_update_pods
    end
  end
end