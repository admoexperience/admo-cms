describe AdmoAccount do
  describe '#publish_update_pods' do
    it 'calls #publish_update_pods on each of its units' do
      account = create(:admo_account)
      account.admo_units << create(:admo_unit)
      account.admo_units << create(:admo_unit)

      account.admo_units.each do |unit|
        unit.should_receive :publish_update_pods
      end

      account.publish_update_pods
    end
  end
end
