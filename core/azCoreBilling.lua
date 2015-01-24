azCoreBilling = {}
local onStoreUpdate = nil
local azClassBillingItems      = {}
local azClassBillingActive     = {}
local azClassBillingIdentifier = {}

-- [[ Android Billing ]]
local function androidListenerCheckBillingSupported ( state )
	azClassBillingActive = state
	if state then
		print ( "Android billing is active." )
	end
end

local function androidListenerPurchaseStateChanges ( code, identifier, order, user, notification, payload )
	if code == MOAIBillingAndroid.BILLING_RESULT_SUCCESS then
		print ( "android success", identifier )
	elseif code == MOAIBillingAndroid.BILLING_RESULT_USER_CANCELED then
		print ( "android cancelled", identifier )
	elseif code == MOAIBillingAndroid.BILLING_RESULT_BILLING_UNAVAILABLE then
		print ( "android unavaible", identifier )
	elseif code == MOAIBillingAndroid.BILLING_RESULT_ITEM_UNAVAILABLE then
		print ( "android item unavaible", identifier )
	elseif code == MOAIBillingAndroid.BILLING_RESULT_ERROR then
		print ( "android error", identifier )
	else
		print ( "android else?" )
	end
	print ( "state", code, identifier, order, user, notification, payload )
	if not MOAIBillingAndroid.confirmNotification ( notification ) then
		print ( "Failed to confirm notification: " .. tostring ( notification ) )
	end
end

local function androidListenerPurchaseReceived ( code, identifier )
	local success = false
	if code == MOAIBillingAndroid.BILLING_PURCHASE_STATE_ITEM_PURCHASED then
		success = true
		print ( "Android purchased" )
	elseif code == MOAIBillingAndroid.BILLING_PURCHASE_STATE_PURCHASE_CANCELED then
		print ( "Android cancelled" )
	elseif code == MOAIBillingAndroid.BILLING_PURCHASE_STATE_ITEM_REFUNDED then
		print ( "Android refunded" )
	end
	print ( "received", code, identifier )
	onStoreUpdate ( azCoreBilling.getItemNameByIdentifier ( identifier ), success )
end

local function androidListenerRestoreResponseReceived ( code, more, offset )
	print ( "onRestoreResponseReceived: ", code )
	if ( code == MOAIBillingAndroid.BILLING_RESULT_SUCCESS ) then
		print ( "restore request received" )
		if more then
			MOAIBillingAndroid.restoreTransactions ( offset )
		end
	else
		print ( "restore request failed" )
	end
end

-- [[ IOS Billing ]]
local function iosPaymentQueueTransaction ( transaction )
	print ( "ios queue: ", transaction.transactionState )
	local success = false
	local shouldCallCallback = true
	if transaction.transactionState == MOAIBillingIOS.TRANSACTION_STATE_PURCHASING then
		shouldCallCallback = false
        print ( "queue purchasing" )
	elseif transaction.transactionState == MOAIBillingIOS.TRANSACTION_STATE_PURCHASED then
		success = true
        print ( "queue purchased" )
	elseif transaction.transactionState == MOAIBillingIOS.TRANSACTION_STATE_CANCELLED then
        print ( "queue cancelled" )
	elseif transaction.transactionState == MOAIBillingIOS.TRANSACTION_STATE_FAILED then
        print ( "queue fail" )
	elseif transaction.transactionState == MOAIBillingIOS.TRANSACTION_STATE_RESTORED then
		success = true
        print ( "queue restored" )
	end
    if transaction.error ~= nil then
        print ( "Error: " .. transaction.error )
    end
	if shouldCallCallback then
        print ( "xd> " .. tostring ( transaction.payment.productIdentifier ) )
		onStoreUpdate(azCoreBilling.getItemNameByIdentifier(transaction.payment.productIdentifier), success)
	end
end

local function iosPaymentQueueError ( error, extraInfo )
	print ( "ios error: ", error )
	onStoreUpdate ( azCoreBilling.getItemNameByIdentifier ( azClassBillingIdentifier ), false )
end

local function iosPaymentRestoreFinished ()
end

local function iosProductRequestResponse ( transactions )
	for _, transaction in ipairs ( transactions ) do
		--[[transaction.localizedTitle
		transaction.localizedDescription
		transaction.price
		transaction.localizedPrice
		transaction.productIdentifier]]
	end
end

-- [[ Engine Functions ]]
function azCoreBilling.init ()
	if MOAIBillingAndroid ~= nil then
		print ( "Starting android billing." )
		MOAIBillingAndroid.setListener        ( MOAIBillingAndroid.PURCHASE_STATE_CHANGED    , androidListenerPurchaseStateChanges    )
		MOAIBillingAndroid.setListener        ( MOAIBillingAndroid.CHECK_BILLING_SUPPORTED   , androidListenerCheckBillingSupported   )
		MOAIBillingAndroid.setListener        ( MOAIBillingAndroid.PURCHASE_RESPONSE_RECEIVED, androidListenerPurchaseReceived        )
		MOAIBillingAndroid.setListener        ( MOAIBillingAndroid.RESTORE_RESPONSE_RECEIVED , androidListenerRestoreResponseReceived )
		MOAIBillingAndroid.setBillingProvider ( MOAIBillingAndroid.BILLING_PROVIDER_GOOGLE )
		MOAIBillingAndroid.setPublicKey ( 'Codigo Obitido Pós Publicação no Market' )
		MOAIBillingAndroid.checkBillingSupported ()
	elseif MOAIBillingIOS ~= nil then
		MOAIBillingIOS.setListener ( MOAIBillingIOS.PAYMENT_QUEUE_ERROR      , iosPaymentQueueError	      )
		MOAIBillingIOS.setListener ( MOAIBillingIOS.PAYMENT_RESTORE_FINISHED , iosPaymentRestoreFinished  )
		MOAIBillingIOS.setListener ( MOAIBillingIOS.PAYMENT_QUEUE_TRANSACTION, iosPaymentQueueTransaction )
		MOAIBillingIOS.setListener ( MOAIBillingIOS.PRODUCT_REQUEST_RESPONSE , iosProductRequestResponse  )
		print ( "Starting ios billing." )
		if MOAIBillingIOS.canMakePayments () then
			azClassBillingActive = true
			print ( "Billing avaible." )
		else
			print ( "Billing is not avaible." )
		end
	end
    extends ( azClassBillingItems, azCoreGlobal.coreFunctions )
	doFileSandbox ( azClassBillingItems, 'project/'.._Project..'/resources/billing/configBilling.lua' )
end

function azCoreBilling.getItemNameByIdentifier ( identifier )
	for name, value in pairs ( azClassBillingItems.items ) do
		print (name , value)
		if MOAIBillingAndroid ~= nil and value.codeAndroid == identifier then
			return name
		elseif MOAIBillingIOS ~= nil and value.codeIOS == identifier then
			return name
		end
	end
end

function azCoreBilling.setCallback ( callback )
	onStoreUpdate = callback
end

function azCoreBilling.purchase ( name )
	if not azClassBillingActive then
		onStoreUpdate ( name, false )
		return false
	end
	local item = azClassBillingItems.items [ name ]
	if item == nil then
		error ( "billing " .. tostring (name ) .. " not found in billing.lua" )
		onStoreUpdate ( name, false )
		return false
	end
	if type ( onStoreUpdate ) ~= 'function' then
		error ( 'purchase callback is not a function' )
		onStoreUpdate ( name, false )
		return false
	end
	local identifier = ''
	if MOAIBillingAndroid ~= nil then
		identifier = item.codeAndroid
	else
		identifier = item.codeIOS
	end
	if identifier == nil then
		onStoreUpdate ( 'nil', false )
		return false
	end
	azClassBillingIdentifier = identifier
	print ( "Purchasing: " .. name )
	if MOAIBillingAndroid ~= nil then
		return MOAIBillingAndroid.requestPurchase ( identifier )
	elseif MOAIBillingIOS ~= nil then
		return MOAIBillingIOS.requestPaymentForProduct ( identifier )
	end
	return false
end