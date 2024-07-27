<?php

namespace App\Traits;

use PhpParser\Builder\Trait_;

Trait responseTrait{

    public function returnError($errNum, $msg){
        return response()->json([

            "status" => false,
            "errNum" => $errNum,
            "msg" => $msg

        ]);
    }

    public function returnData($key,$value,$msg){

        return response()->json([

            "status" => true,
            "errNum" => "S000",
            "msg" => $msg,
            $key => $value

        ]);

    }

    public function returnSuccess($msg){

        return response()->json([

            "status" => true,
            "errNum" => "S000",
            "msg" => $msg,
        ]);

    }

}

?>