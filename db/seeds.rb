user = User.create(
  [{:username => 'revence', :is_admin => false, :sha1_salt => 'mwahaha', :sha1_pass => 'e643004bb0ad15b6fd350c641f78cb10d46132f5'},
   {:username => 'sharad', :is_admin => true,   :sha1_salt => 'hehehe',  :sha1_pass => '215822e8636cc2aaa8223147d823f02e4344550c'}])

# Geography

ug = Country.create :name => 'Uganda'
central = Region.create :name => 'Central'
wakiso = District.create :name => 'Wakiso'
entebbe = SubCounty.create :name => 'Entebbe'
katabi = Parish.create :name => 'Namate'
manyago = Village.create :name => 'Manyago I'

katabi.villages << manyago
entebbe.parishes << katabi
wakiso.sub_counties << entebbe
wakiso.district_data = DistrictData.create(:population =>  1_260_900)
central.districts << wakiso
ug.regions << central

component = Component.create :name => 'PMTCT'
activity  = Activity.create(:name => 'Testing Mothers')
item1     = ActivityItem.create(:name => 'determine_kit', :description => 'Determine HIV Test Kits')
item2     = ActivityItem.create(:name => 'statpak_kit', :description => 'StatPak HIV Test Kits')
item3     = ActivityItem.create(:name => 'unigold_kit', :description => 'Unigold HIV Test Kits')

activity.activity_items << item1
activity.activity_items << item2
activity.activity_items << item3

component.activities << activity
component.save
