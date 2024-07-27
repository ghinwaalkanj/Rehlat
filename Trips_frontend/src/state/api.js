import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";
import {
  setCookie,
  getCookie,
  eraseCookie,
  deleteCookie,
} from "../utils/helperFunction";

// let tokenTimeout; // Variable to hold the timeout reference

// // Function to reset the token timeout
// const resetTokenTimeout = () => {
//   clearTimeout(tokenTimeout); // Clear the existing timeout
//   // Set a new timeout for 5 minutes (300,000 milliseconds)
//   console.log('hiiiiiiidelete')
//   tokenTimeout = setTimeout(() => {

//     eraseCookie("token");
//     deleteCookie("token");
//   }, 9000); // 5 minutes in milliseconds 300000
// };
let lastRequestTime = Date.now();
document.addEventListener("click", () => {
  // console.log("here333");
  lastRequestTime = Date.now();
});

export const api = createApi({
  baseQuery: fetchBaseQuery({
    baseUrl: process.env.REACT_APP_BASE_URL,
    prepareHeaders: (headers, { getState }) => {
      const token = getCookie("token");
      const dToken = getCookie("d_token");
      // If we have a token set in state, let's assume that we should be passing it.
      if (token) {
        headers.set("authorization", `Bearer ${token}`);
      }
      if (dToken) {
        headers.set("authorization", `Bearer ${dToken}`);
      }
      const inactivityTimeout = 5 * 60 * 1000;
      // const inactivityTimeout = 30000;
      const now = Date.now();
      if (now - lastRequestTime > inactivityTimeout) {
        // console.log("here1111");
        eraseCookie("token");
        deleteCookie("token");
        lastRequestTime = Date.now();
        window.location.href = "/";
      } else {
        // console.log("here2222");
        lastRequestTime = Date.now();
      }

      return headers;
    },
    validateStatus: (p, response) => {
      if (p.status === 401) {
        window.location.href = "/";
        return false;
      }
      return true;
    },
  }),
  reducerPath: "adminApi",
  tagTypes: [
    "User",
    "Products",
    "Trips",
    "Customers",
    "Transactions",
    "Geography",
    "Sales",
    "Admins",
    "Performance",
    "Dashboard",
  ],
  endpoints: (build) => ({
    getCities: build.query({
      query: () => "cities",
      providesTags: ["Cities"],
    }),
    getTrips: build.query({
      query: () => "companies/trips",
      providesTags: ["Trips"],
    }),
    getTripInfo: build.query({
      query: (id) => `companies/trips/${id}`,
      providesTags: ["Trips"],
    }),
    getTripListInfo: build.query({
      query: (id) => `companies/trip-list/${id}`,
      providesTags: ["TripsList"],
    }),
    getTripList: build.query({
      query: () => `/companies/trip-list`,
      providesTags: ["TripList"],
    }),
    getBuses: build.query({
      query: () => `/companies/buses`,
      providesTags: ["Buses"],
    }),
    getDrivers: build.query({
      query: () => `/companies/drivers`,
      providesTags: (result, error, arg) => {
        console.log("result", result);
        if (result) {
          return [
            // { type: "Drivers", id: "LIST" },
            ...result.data.drivers.map(({ id }) => ({ type: "Drivers", id })),
            "Drivers",
          ];
        } else return [{ type: "Drivers", id: "LIST" }];
      },
    }),
    getAssistants: build.query({
      query: () => `/companies/drivers-assistant`,
      providesTags: (result, error, arg) => {
        console.log("result", result);
        if (result) {
          return [
            { type: "Assistants", id: "LIST" },
            ...result.data.drivers_assistant.map(({ id }) => ({
              type: "Assistants",
              id,
            })),
          ];
        } else return [{ type: "Assistants", id: "LIST" }];
      },
    }),
    searchTrip: build.query({
      query: (id) => `companies/trips/${id}`,
      providesTags: ["Trips"],
    }),
    getTripReservations: build.query({
      query: (id) => `companies/reservations/${id}`,
      providesTags: ["Reservation"],
    }),
    confirmReservation: build.mutation({
      query: (reservation_id) => ({
        url: `/companies/confirm-reservation/${reservation_id}`,
        method: "POST",
      }),
      invalidatesTags: (result, error, arg) => ["Reservation"],
    }),
    selectSeat: build.mutation({
      query: (seat_id) => ({
        url: "/companies/trips/select-seat",
        method: "POST",
        body: {
          ...seat_id,
        },
      }),
      invalidatesTags: (result, error, arg) => [{ type: "Trips", id: arg.id }],
    }),
    unselectSeat: build.mutation({
      query: (seat_id) => ({
        url: "/companies/trips/unselect-seat",
        method: "POST",
        body: {
          ...seat_id,
        },
      }),
      invalidatesTags: (result, error, arg) => [{ type: "Trips", id: arg.id }],
    }),
    tripList: build.mutation({
      query: (data) => ({
        url: "/companies/trip-list",
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: (result, error, arg) => ["TripList", "Trips"],
    }),
    finishTripList: build.mutation({
      query: (id) => ({
        url: `companies/trip-list/finish/${id}`,
        method: "POST",
        body: {},
      }),
      invalidatesTags: (result, error, arg) => ["TripList", "Trips"],
    }),
    addBus: build.mutation({
      query: (data) => ({
        url: "/admin/buses",
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: (result, error, arg) => [{ type: "Buses", id: arg.id }],
    }),
    addDriver: build.mutation({
      query: (data) => ({
        url: "/companies/drivers",
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: ["Drivers"],
    }),
    addCity: build.mutation({
      query: (data) => ({
        url: "/admin/cities",
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: ["Cities"],
    }),
    addAssistant: build.mutation({
      query: (data) => ({
        url: "/companies/drivers-assistant",
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: [{ type: "Assistants", id: "LIST" }],
    }),
    deleteBus: build.mutation({
      query: (id) => ({
        url: `/admin/buses/delete/${id}`,
        method: "POST",
      }),
      invalidatesTags: (result, error, arg) => [{ type: "Buses", id: arg.id }],
    }),
    deleteDriver: build.mutation({
      query: (id) => ({
        url: `/companies/drivers/delete/${id}`,
        method: "POST",
      }),
      invalidatesTags: (result, error, arg) => [
        { type: "Drivers", id: arg.id },
      ],
    }),
    deleteAssistant: build.mutation({
      query: (id) => ({
        url: `/companies/drivers-assistant/delete/${id}`,
        method: "POST",
      }),
      invalidatesTags: (result, error, arg) => [
        { type: "Assistants", id: arg.id },
      ],
    }),
    updateDriver: build.mutation({
      query: (data) => ({
        url: `/companies/drivers/update`,
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: (result, error, arg) => {
        return [{ type: "Drivers", id: arg.id }];
      },
    }),
    updateAssistant: build.mutation({
      query: (data) => ({
        url: `/companies/drivers-assistant/update`,
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: (result, error, arg) => {
        return [{ type: "Assistants", id: arg.id }];
      },
    }),
    updateTripList: build.mutation({
      query: (data) => {
        return {
          url: `/companies/trip-list/${data.id}`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["TripList", "TripsList"],
    }),
    updateTrip: build.mutation({
      query: (data) => {
        return {
          url: `/companies/trips/${data.id}`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["Trips"],
    }),
    reserveSeat: build.mutation({
      query: (data) => ({
        url: "/companies/reserve-seats",
        method: "POST",
        body: {
          ...data,
        },
      }),
      invalidatesTags: (result, error, arg) => [{ type: "Trips", id: arg.id }],
    }),
    getDashboard: build.query({
      query: () => "general/dashboard",
      providesTags: ["Dashboard"],
    }),
    getClaims: build.query({
      query: ({ page }) => ({
        url: "/admin/claims",
        method: "GET",
        params: { page },
      }),
      providesTags: ["Claims"],
    }),
    getUsers: build.query({
      query: ({ page }) => ({
        url: "/admin/users",
        method: "GET",
        params: { page },
      }),
      providesTags: ["Users"],
    }),
    getCompanies: build.query({
      query: () => "/admin/companies",
      providesTags: ["Companies"],
    }),
    getCompany: build.query({
      query: (id) => `/admin/companies/${id}`,
      providesTags: ["Companies"],
    }),
    getCompanyUsers: build.query({
      query: () => "/companies/users",
      providesTags: ["CompanyUsers"],
    }),
    getPermission: build.query({
      query: () => "/companies/permissions",
      providesTags: ["Permissions"],
    }),
    getStatsForAdmin: build.query({
      query: () => "/admin/stats",
      providesTags: ["AdminStats"],
    }),
    getStats1ForAdmin: build.query({
      query: (period) => `/admin/stats1?period=${period}`,
      providesTags: ["AdminStats"],
      keepUnusedDataFor: 0,
    }),
    getStats1ForCompany: build.query({
      query: (period) => `/companies/stats1?period=${period}`,
      providesTags: ["CompanyStats"],
      keepUnusedDataFor: 0,
    }),
    getStatsForCompany: build.query({
      query: () => "/companies/stats",
      providesTags: ["CompanyStats"],
    }),
    getParams: build.query({
      query: () => "/admin/params",
      providesTags: ["Params"],
    }),
    updateParams: build.mutation({
      query: (data) => {
        return {
          url: `/admin/params`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["Params"],
    }),
    updateCompany: build.mutation({
      query: (data) => {
        const formData = new FormData();
        for (let value in data) {
          formData.append(value, data[value]);
        }
        return {
          url: `/admin/companies/update/${data.id}`,
          method: "POST",
          // headers: {
          //   "Content-Type": "multipart/form-data",
          // },
          body: formData,
          formData: true,
        };
      },
      // query: (data) => {
      //   return {
      //     url: `/admin/companies/update/${data.id}`,
      //     method: "POST",
      //     body: {
      //       ...data,
      //     },
      //   };
      // },
      invalidatesTags: (result, error, arg) => ["Companies"],
    }),
    answerClaim: build.mutation({
      query: (data) => {
        return {
          url: `/admin/claims/answer`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["Claims"],
    }),
    changeStatusClaim: build.mutation({
      query: (data) => {
        return {
          url: `/admin/claims/status`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["Claims"],
    }),
    changeStatusUser: build.mutation({
      query: (data) => {
        return {
          url: `/admin/users/status`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["Users"],
    }),
    getGatewaysStatus: build.query({
      query: () => "/admin/gateways_status",
      providesTags: ["GatewaysStatus"],
    }),
    getCompanyUserById: build.query({
      query: (id) => `/companies/users/${id}`,
      providesTags: ["CompanyUsers"],
    }),
    activeOrInactiveCompanyUserById: build.mutation({
      query: (id) => {
        return {
          url: `/companies/users/active/${id}`,
          method: "POST",
          body: {},
        };
      },
      invalidatesTags: (result, error, arg) => ["CompanyUsers"],
    }),
    updateGatewaysStatus: build.mutation({
      query: (data) => {
        return {
          url: `/admin/gateways_status`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["GatewaysStatus"],
    }),
    addCompany: build.mutation({
      query: (data) => {
        const formData = new FormData();
        for (let value in data) {
          formData.append(value, data[value]);
        }
        return {
          url: "/admin/companies",
          method: "POST",
          // headers: {
          //   "Content-Type": "multipart/form-data",
          // },
          body: formData,
          formData: true,
        };
      },
      invalidatesTags: ["Companies"],
    }),
    addCompanyUser: build.mutation({
      query: (data) => {
        return {
          url: `/companies/users`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["CompanyUsers"],
    }),
    updateCompanyUser: build.mutation({
      query: (data) => {
        return {
          url: `/companies/users/update`,
          method: "POST",
          body: {
            ...data,
          },
        };
      },
      invalidatesTags: (result, error, arg) => ["CompanyUsers"],
    }),
    cancelTrip: build.mutation({
      query: (id) => {
        return {
          url: `/companies/trip/cancel/${id}`,
          method: "POST",
        };
      },
      invalidatesTags: (result, error, arg) => ["Trips"],
    }),
  }),
});

export const {
  useGetDashboardQuery,
  useGetTripsQuery,
  useGetTripInfoQuery,
  useSelectSeatMutation,
  useUnselectSeatMutation,
  useReserveSeatMutation,
  useGetTripReservationsQuery,
  useConfirmReservationMutation,
  useGetCitiesQuery,
  useTripListMutation,
  useSearchTripQuery,
  useGetTripListQuery,
  useGetTripListInfoQuery,
  useUpdateTripListMutation,
  useGetBusesQuery,
  useAddBusMutation,
  useDeleteBusMutation,
  useGetDriversQuery,
  useAddDriverMutation,
  useDeleteDriverMutation,
  useUpdateDriverMutation,
  useGetAssistantsQuery,
  useAddAssistantMutation,
  useDeleteAssistantMutation,
  useUpdateAssistantMutation,
  useUpdateTripMutation,
  useGetClaimsQuery,
  useGetCompaniesQuery,
  useAddCompanyMutation,
  useGetCompanyUsersQuery,
  useGetPermissionQuery,
  useAddCompanyUserMutation,
  useGetParamsQuery,
  useUpdateParamsMutation,
  useGetGatewaysStatusQuery,
  useUpdateGatewaysStatusMutation,
  useCancelTripMutation,
  useGetCompanyQuery,
  useUpdateCompanyMutation,
  useAnswerClaimMutation,
  useChangeStatusClaimMutation,
  useGetCompanyUserByIdQuery,
  useUpdateCompanyUserMutation,
  useActiveOrInactiveCompanyUserByIdMutation,
  useFinishTripListMutation,
  useAddCityMutation,
  useGetStatsForAdminQuery,
  useGetStatsForCompanyQuery,
  useGetStats1ForAdminQuery,
  useGetStats1ForCompanyQuery,
  useGetUsersQuery,
  useChangeStatusUserMutation,
} = api;
