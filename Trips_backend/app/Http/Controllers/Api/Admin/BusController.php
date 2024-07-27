<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Bus;
use DateTime;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Date;

class BusController extends ApiController
{
    public function index()
    {
       
        if (auth('admin')->check()) {
            $buses = Bus::all();
        } else {
            $buses = Bus::whereNull('deleted_at')->get();
        }

        return $this->apiResponse([
            'buses' => $buses,
        ], self::STATUS_OK, 'get buses successfully');
    }
    public function store(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'name' => 'required',
            'number_seat' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;

        $bus = Bus::create([
            'name' => $request->name,
            'number_seat' => $request->number_seat,
        ]);
        return $this->apiResponse([], self::STATUS_OK, 'created successfully');
    }

    public function edit(Request $request, $id)
    {
        $bus = Bus::find($id);
        $bus->update($request->all());
        return $this->apiResponse([], self::STATUS_OK, 'updated successfully');
    }

    public function delete($id)
    {
        $bus = Bus::find($id);
        $bus->deleted_at = new DateTime();
        $bus->save();
        return $this->apiResponse([], self::STATUS_OK, 'delete successfully');
    }
}
