# Load the rails application
require File.expand_path('../application', __FILE__)

$SM_ACCOUNT_TZ=900000001
$SM_ACCOUNT_UG=900000002
$FEE=0.01
$ENABLE_TRANSFER_FEE=0


$FEE_CASHIN=0.04
$FEE_CASHIN_COMMISSION=0.01
$FEE_CASHOUT_COMMISSION=0.01

$country_code={}
#Uganda
$country_code['1'] = '256'
#Tanzania
$country_code['2'] = '255'



# Initialize the rails application
Smmoney::Application.initialize!

    