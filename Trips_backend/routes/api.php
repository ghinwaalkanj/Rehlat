<?php

use App\Http\Controllers\Api\Admin\AdminAuthController;
use App\Http\Controllers\Api\Admin\AdminClaimController;
use App\Http\Controllers\Api\Admin\AdminUserController;
use App\Http\Controllers\Api\Admin\BusController;
use App\Http\Controllers\Api\Admin\CompanyController as AdminCompanyController;
use App\Http\Controllers\Api\Admin\ParameterController;
use App\Http\Controllers\Api\Admin\PaymentGatewayStatusController;
use App\Http\Controllers\Api\Admin\StatisticController;
use App\Http\Controllers\Api\Company\AuthController;
use App\Http\Controllers\Api\Company\CompanyPermission as CompanyPermissionController;
use App\Http\Controllers\Api\Company\CompanyReservationController;
use App\Http\Controllers\Api\Company\CompanyTripController;
use App\Http\Controllers\Api\Company\DriverAssistantController;
use App\Http\Controllers\Api\Company\DriverController;
use App\Http\Controllers\Api\Company\TripListController;
use App\Http\Controllers\Api\User\CityController;
use App\Http\Controllers\Api\User\ClaimController;
use App\Http\Controllers\Api\User\CompanyController;
use App\Http\Controllers\Api\User\NotificationController;
use App\Http\Controllers\Api\User\PaymentController;
use App\Http\Controllers\Api\User\ProfileController;
use App\Http\Controllers\Api\User\RateController;
use App\Http\Controllers\Api\User\ResendCodeController;
use App\Http\Controllers\Api\User\ReservationController;
use App\Http\Controllers\Api\User\TripController;
use App\Http\Controllers\Api\User\UserController;
use App\Http\Controllers\MtnController;
use App\Http\Controllers\SyriatelController;
use App\Models\City;
use App\Models\Company;
use App\Models\Seat;
use App\Models\Trip;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});




Route::get('/privacy-policy', function () {
    $filePath = public_path('privacy_policy.html');

    if (File::exists($filePath)) {
        return response(File::get($filePath), 200)
            ->header('Content-Type', 'text/html');
    }

    abort(404);
});
Route::get('/terms-of-use', function () {
    $filePath = public_path('terms_of_use.html');

    if (File::exists($filePath)) {
        return response(File::get($filePath), 200)
            ->header('Content-Type', 'text/html');
    }

    abort(404);
});





Route::get('fatora/paid/{user_id}/{reservation_id}', [PaymentController::class, 'fatora_paid']);

Route::group(['middleware' => 'localization'], function () {
    Route::get('/trips', [TripController::class, 'search']); //
    Route::get('/test', [TripController::class, 'test']);
    Route::get('/methods', [UserController::class, 'methods']);

    Route::post('reservations/payment/fatora', [PaymentController::class, 'createFatoraPayment'])->middleware(['auth', 'mobile_verified', 'jwt_check']);

    Route::get('/send-otp', [UserController::class, 'send_otp'])->middleware('throttle:companies.login');
    Route::post('/phone-verify', [UserController::class, 'validate_phone_number_and_login'])->middleware('throttle:companies.login');;

    Route::get('trips/{id}', [TripController::class, 'getInfo'])->middleware(['auth', 'mobile_verified', 'jwt_check']);

    Route::post('select-seats', [ReservationController::class, 'select_seats'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::post('unselect-seat', [ReservationController::class, 'unselect_seats']);
    Route::post('reserve-seats', [ReservationController::class, 'reserve_seats'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::post('confirm-reservation/{book_id}', [ReservationController::class, 'confirm_reservation'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('request/confirm-reservation/{book_id}', [ReservationController::class, 'request_confirm_reservation'])->middleware(['auth', 'mobile_verified', 'jwt_check']);

    Route::get('profile', [ProfileController::class, 'index'])->middleware(['auth', 'jwt_check', 'mobile_verified']);
    Route::post('profile', [ProfileController::class, 'update'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('booking', [ReservationController::class, 'myBooking'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('request-update-profile', [UserController::class, 'requestUpdateProfile'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::post('update-phone', [ProfileController::class, 'updatePhone'])->middleware('auth');
    Route::post('profile/lang', [ProfileController::class, 'changeLanguage'])->middleware('auth');

    Route::post('send-claim', [ClaimController::class, 'store'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('get-claims', [ClaimController::class, 'getClaims'])->middleware(['auth', 'mobile_verified', 'jwt_check']);

    Route::post('update-fcm', [UserController::class, 'updateFcm']);

    Route::get('notifications', [NotificationController::class, 'index'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('check-trip', [RateController::class, 'checkRate'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::post('rate-trip', [RateController::class, 'rateTrip'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('/cities', [CityController::class, 'index']);
    Route::get('/companies', [CompanyController::class, 'index']);


    Route::get('/resend/update-profile', [ResendCodeController::class, 'updateProfile'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('/resend/confirm-reservation', [ResendCodeController::class, 'requestConfirmReservation'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('/resend/request-update-profile', [ResendCodeController::class, 'requestUpdateProfile'])->middleware(['auth', 'mobile_verified', 'jwt_check']);
    Route::get('/resend/send-otp', [ResendCodeController::class, 'sendOtp']);

    Route::get('/request-cancel-reservation/{book_id}', [ReservationController::class, 'request_cancel_reservation']);
    Route::post('/cancel-reservation', [ReservationController::class, 'remove_reserve_temp']);




    Route::post('/clear-cache', function () {
        Artisan::call('cache:clear');
        Artisan::call('config:clear');
        Artisan::call('route:clear');
        Artisan::call('view:clear');
        return response()->json(['message' => 'Cache cleared successfully']);
    });
});



//! ********************************** companies api

Route::post('companies/login', [AuthController::class, 'login'])->name('companies.login')->middleware('throttle:7,7');

Route::get('trip/find', [CompanyTripController::class, 'search']);
Route::get('reservation/find', [CompanyTripController::class, 'searchForReservation']);

Route::group(['middleware' => ['auth:company'], "prefix" => "companies"], function () {
    Route::get('/trips', [CompanyTripController::class, 'index']);
    Route::post('/trips/select-seat', [CompanyReservationController::class, 'select_seats']);
    Route::post('/trips/unselect-seat', [CompanyReservationController::class, 'unselect_seats']);
    Route::get('/trips/{id}', [CompanyTripController::class, 'getTripInfo']);
    Route::post('/trips/{id}', [CompanyTripController::class, 'update']);
    Route::post('/reserve-seats', [CompanyReservationController::class, 'reserve_seats']);
    Route::post('/confirm-reservation/{reservation_id}', [CompanyReservationController::class, 'confirm_reservation']);
    Route::get('/reservations/{trip_id}', [CompanyReservationController::class, 'getReservationsByTripId']);
    Route::get('/trip-list', [TripListController::class, 'index']);
    Route::post('/trip-list', [TripListController::class, 'store']);
    Route::get('/trip-list/{id}', [TripListController::class, 'getById']);
    Route::post('/trip-list/{id}', [TripListController::class, 'update']);
    Route::post('/trip-list/finish/{id}', [TripListController::class, 'delete']);
    Route::post('/trip/cancel/{id}', [CompanyTripController::class, 'cancelTrip']);

    Route::get('/drivers', [DriverController::class, 'index']);
    Route::post('/drivers', [DriverController::class, 'store']);;
    Route::post('/drivers/update', [DriverController::class, 'update']);
    Route::post('/drivers/delete/{id}', [DriverController::class, 'delete']);

    Route::get('/drivers-assistant', [DriverAssistantController::class, 'index']);
    Route::post('/drivers-assistant', [DriverAssistantController::class, 'store']);
    Route::post('/drivers-assistant/update', [DriverAssistantController::class, 'update']);
    Route::post('/drivers-assistant/delete/{id}', [DriverAssistantController::class, 'delete']);


    Route::get('/users', [CompanyPermissionController::class, 'index']);
    Route::get('/users/{id}', [CompanyPermissionController::class, 'getUserCompanyById']);
    Route::post('/users', [CompanyPermissionController::class, 'store']);
    Route::post('/users/update', [CompanyPermissionController::class, 'update']);
    Route::get('/permissions', [CompanyPermissionController::class, 'getPermissions']);
    Route::post('/users/active/{id}', [CompanyPermissionController::class, 'activeOrInactive']);


    Route::get('/stats', [StatisticController::class, 'forCompany']);
    Route::get('/stats1', [StatisticController::class, 'dashboardCompany']);
});

Route::get('companies/buses', [BusController::class, 'index']);


//! ********************************** admins api


Route::post('admin/login', [AdminAuthController::class, 'login']);

Route::group(['middleware' => ['auth:admin'], "prefix" => "admin"], function () {
    Route::post('/buses', [BusController::class, 'store']);
    Route::post('/buses/delete/{id}', [BusController::class, 'delete']);
    Route::get('/claims', [AdminClaimController::class, 'index']);
    Route::post('/claims/status', [AdminClaimController::class, 'changeStatus']);
    Route::post('/claims/answer', [AdminClaimController::class, 'answer']);
    Route::get('/params', [ParameterController::class, 'index']);
    Route::post('/params', [ParameterController::class, 'update']);
    Route::get('/gateways_status', [PaymentGatewayStatusController::class, 'index']);
    Route::post('/gateways_status', [PaymentGatewayStatusController::class, 'update']);
    Route::post('/cities', [CityController::class, 'create']);
    Route::get('/companies', [AdminCompanyController::class, 'index']);
    Route::get('/companies/{id}', [AdminCompanyController::class, 'getCompanyById']);
    Route::post('/companies', [AdminCompanyController::class, 'store']);
    Route::post('/companies/update/{id}', [AdminCompanyController::class, 'update']); 
    Route::get('/users', [AdminUserController::class, 'getUsers']);
    Route::post('/users/status', [AdminUserController::class, 'changeStatus']);
    Route::get('/stats', [StatisticController::class, 'forAdmin']);
    Route::get('/stats1', [StatisticController::class, 'dashboardAdmin']);
});









Route::group(['prefix' => 'mtn'], function () {
    Route::post('init-payment', [MtnController::class, 'createPayment'])->middleware(['auth', 'jwt_check', 'mobile_verified']);
    Route::post('confirm-payment', [MtnController::class, 'confirmPayment'])->middleware(['auth', 'jwt_check', 'mobile_verified']);
});

Route::group(['prefix' => 'syriatel'], function () {

 

    Route::post('init-payment', [SyriatelController::class, 'requestPayment'])->middleware(['auth', 'jwt_check', 'mobile_verified']);
    Route::post('confirm-payment', [SyriatelController::class, 'sendOtp'])->middleware(['auth', 'jwt_check', 'mobile_verified']);
    Route::post('resend-otp', [SyriatelController::class, 'resendOtp'])->middleware(['auth', 'jwt_check', 'mobile_verified']);
});
