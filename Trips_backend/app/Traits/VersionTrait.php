<?php

namespace App\Traits;

use App\Models\AndroidVersion;
use App\Models\IosVersion;
use Illuminate\Http\Request;
use PhpParser\Builder\Trait_;

trait VersionTrait
{

    public function checkAndroid(Request $request)
    {
        $lawyer = auth('lawyer')->user();
        if($lawyer && $lawyer->iso == 'sy')    return false;
        $requestVersion = $request->header('version');
        $lastVersion = AndroidVersion::latest()->first()->android_version;
        if($lastVersion && $requestVersion)
        {
            // if($lastVersion->android_version == 1)  return false;
            $lastVersion = explode('.',$lastVersion);
            $requestVersion = explode('.',$requestVersion);
            // dd($requestVersion[1]);
            if ($lastVersion[0] < $requestVersion[0] )
                 return true;
                if($lastVersion[1] < $requestVersion[1] )
                 return true;
                if($lastVersion[2] < $requestVersion[2])
                 return true;
            return false;
        }

        return true;
    //   return false;
        //check with api google
    //     $lawyer = auth('lawyer')->user();
    //     if($lawyer->iso == 'sy')
    //         return false;
    //     $requestVersion = $request->header('version');
    //     // $requestVersion = str_replace('.','',$requestVersion);
    //    if($requestVersion)
    //    {
    //         $requestVersion = explode('.',$requestVersion);

    //         $package = 'com.perlatech.lowyerjournal';
    //         $html = file_get_contents('https://play.google.com/store/apps/details?id=' . $package . '&hl=en');
    //     if(!$html)  return false;

    //         $matches = [];
    //         preg_match('/\[\[\[\"\d+\.\d+\.\d+/', $html, $matches);
    //         if (empty($matches) || count($matches) > 1) {
    //             throw new Exception('Could not fetch Android app version info!');
    //         }
    //         $currentVersion =  substr(current($matches), 4);
    //         // $currentVersion = '1.2.33';
    //         $currentVersionArr = explode('.',$currentVersion);
    //         // dd($currentVersionArr , $requestVersion);

    //         // if (str_replace('.','',$currentVersion) < $requestVersion) return true;
    //         if ($currentVersionArr[0] < $requestVersion[0] )
    //             return true;
    //         if($currentVersionArr[1] < $requestVersion[1] )
    //             return true;
    //         if($currentVersionArr[2] < $requestVersion[2])
    //             return true;
    //         return false;
    //    }else{
    //     return true;
    //    }


        // check from dashboard

    }


    public function checkApple(Request $request)
    {
        $lawyer = auth('lawyer')->user();
        if($lawyer && $lawyer->iso == 'sy')    return false;
        $requestVersion = $request->header('version');
        $lastVersion = IosVersion::latest()->first()->ios_version;
        if($lastVersion && $requestVersion)
        {
            // if($lastVersion->android_version == 1)  return false;
            $lastVersion = explode('.',$lastVersion);
            $requestVersion = explode('.',$requestVersion);
            if ($lastVersion[0] < $requestVersion[0] )
                return true;
            if($lastVersion[1] < $requestVersion[1] )
                return true;
            if($lastVersion[2] < $requestVersion[2])
                return true;
            return false;
        }
        return true;
        // return true;
        // $lawyer = auth('lawyer')->user();
        // if($lawyer->iso == 'sy')
        //     return false;
        // $requestVersion = $request->header('version');
        // if($requestVersion)
        // {

        //     $requestVersion = explode('.',$requestVersion);

        //     // $response = file_get_contents("https://itunes.apple.com/lookup?id=317469184&entity=software");
        // //shaki
        // $response = file_get_contents("https://itunes.apple.com/lookup?id=657859874596&entity=software");
        // if(!$response)  return false;
        // $result = json_decode($response);
        // if(empty($result->results))
        //     return true;
        // $currentVersion  = $result->results[0]->version;
        // $currentVersionArr = explode('.',$currentVersion);
        //     // dd($currentVersionArr , $requestVersion);

        // if($currentVersionArr[0] < $requestVersion[0])     return true;
        // if($currentVersionArr[1] < $requestVersion[1])     return true;
        // if($currentVersionArr[2] < $requestVersion[2])     return true;
        //     return false;
        // }else{
        //     return true;

        // }



        // check from dashboard

    

                if ($request->header('version') == null) return true;

                if (auth('lawyer')->check()) {
                        $lawyer = auth('lawyer')->user();
                        if ($lawyer && $lawyer->iso == 'sy')    return false;
                        $requestVersion = $request->header('version');
                        //dd($requestVersion);
                        $requestVersion = explode('.', $request->header('version'));
                        $lastVersion = IosVersion::latest()->first();
                        //	dd($lastVersion);
                        if ($lastVersion && $requestVersion) {
                                if ($lastVersion->android_version == 1)  return false;
                                $lastVersion = explode('.', $lastVersion);
                                //dd(['ls'=>$lastVersion[0],'rv'=>$requestVersion[0]  ]);
                                if ($lastVersion[0] < $requestVersion[0])
                                        return true;
                                if ($lastVersion[1] < $requestVersion[1])
                                        return true;
                                if ($lastVersion[2] < $requestVersion[2])
                                        return true;
                                return false;
                        }
                        return true;


                        return true;
                } //

        }
}
