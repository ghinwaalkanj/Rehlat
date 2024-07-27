<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class MobileVerified
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $mobile_verified = auth()->user()->mobile_verified;
        if (!$mobile_verified) {
            return response()->json([
                'message' => __('api_response.mobile_verified')
            ], 425);
        }
        $check_status = auth()->user()->status;
        if (!$check_status) {
            return response()->json([
                'message' => "you can't access this route because your account is deactivated"
            ], 403);
        }
        return $next($request);
    }
}
