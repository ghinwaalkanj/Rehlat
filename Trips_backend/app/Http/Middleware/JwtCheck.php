<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;

class JwtCheck
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = auth()->user();
       
        // Check if the jti claim exists and matches the stored value
        if ($user && auth()->payload()->get('jti') !== $user->jti) {
            // Handle the case where the token is invalid
            return response()->json(['error' => 'Invalid token','user_jti'=>$user->jti,'real'=>auth()->payload()->get('jti')], 401);
        }

        return $next($request);
    }
}
