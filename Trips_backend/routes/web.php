<?php

use App\Http\Controllers\MtnController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// Route::get('socket',function(){
//     broadcast(new \App\Events\SeatEvent(2,'unselected',11));
// });


Route::get('mtn',[MtnController::class,'activateMtn']);
Route::get('mtn-p',[MtnController::class,'createPayment']);
Route::get('make-p',[MtnController::class,'makePayment']);
Route::get('make-c',[MtnController::class,'confirmPayment']);



Route::group(['middleware'=>'localization'],function(){
    Route::get('/test',function(){
        return trans('api_response.welcome');
    });
});