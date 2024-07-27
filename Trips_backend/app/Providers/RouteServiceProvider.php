<?php

namespace App\Providers;

use App\Models\Parameter;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Route;

class RouteServiceProvider extends ServiceProvider
{
    /**
     * The path to your application's "home" route.
     *
     * Typically, users are redirected here after authentication.
     *
     * @var string
     */
    public const HOME = '/home';

    /**
     * Define your route model bindings, pattern filters, and other route configuration.
     */
    public function boot(): void
    {
        $params = Parameter::first();
        RateLimiter::for('companies.login', function (Request $request) use ($params) {
            // return Limit::perMinute(30)->by($request->user()?->id ?: $request->ip());
            //min , max request
            return   Limit::perMinutes($params->minute_try_otp??5, $params->max_requests??5)->by($request->user()?->id ?: $request->ip());
        });


        $this->routes(function () {
            Route::middleware('api')
                ->prefix('api/v1')
                ->group(base_path('routes/api.php'));

            Route::middleware('web')
                ->group(base_path('routes/web.php'));
        });
    }
}
