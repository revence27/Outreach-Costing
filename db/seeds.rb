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
wakiso.district_data = DistrictData.create(:population  =>  1_260_900,
                                           :under_one   =>  46_790,
                                           :one_to_four =>  172_720,
                                           :pregnancies =>  14_048)
central.districts << wakiso

kalangala = District.create :name => 'Kalangala'
entebbe = SubCounty.create :name => 'Ssesse Islands'
katabi = Parish.create :name => 'Bunjako'
manyago = Village.create :name => 'Bunjako Island'

katabi.villages << manyago
entebbe.parishes << katabi
kalangala.sub_counties << entebbe
kalangala.district_data = DistrictData.create(:population  =>  58_100,
                                              :under_one   =>  1_890,
                                              :one_to_four =>  6_470,
                                              :pregnancies =>  9_491)
central.districts << kalangala

ug.regions << central

eastern = Region.create :name => 'Eastern'
tororo  = District.create :name => 'Tororo'
entebbe = SubCounty.create :name => 'Tororo'
katabi = Parish.create :name => 'Tororo'
manyago = Village.create :name => 'The Rock'

katabi.villages << manyago
entebbe.parishes << katabi
tororo.sub_counties << entebbe
tororo.district_data = DistrictData.create(:population  =>  463_600,
                                           :under_one   =>  26_410,
                                           :one_to_four =>  89_430,
                                           :pregnancies =>  57_880)
eastern.districts << tororo
ug.regions << eastern

# Components

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

# Assumptions.
# First, the demographic ones.

asscat   = 'demographics'
hiv_preg = Assumption.create(:name     => 'Expected HIV+ Pregnancies',
                             :category => asscat,
                             :label    => :hiv_preg,
                             :units    => :people,
                             :value    => (6.5 / 100.0))

asscat = 'pmtct'
determine = Assumption.create(:name     => 'Determine HIV Test Kits',
                             :category => asscat,
                             :label    => :determine_kit,
                             :units    => :kits,
                             :value    => 1.0)

statpak = Assumption.create(:name      => 'StatPak HIV Test Kits',
                             :category => asscat,
                             :label    => :statpak_kit,
                             :units    => :kits,
                             :value    => (30.0 / 100.0))

determine = Assumption.create(:name     => 'unigold HIV Test Kits',
                             :category => asscat,
                             :label    => :unigold_kit,
                             :units    => :kits,
                             :value    => (2.0 / 100.0))

