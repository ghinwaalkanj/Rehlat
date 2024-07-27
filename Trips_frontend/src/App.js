import { Box, CssBaseline, ThemeProvider } from "@mui/material";
import { createTheme } from "@mui/material/styles";
import { useMemo, Suspense, lazy, useEffect } from "react";
import { useSelector } from "react-redux";
import {
  BrowserRouter,
  Navigate,
  Outlet,
  Route,
  Routes,
} from "react-router-dom";
import { themeSettings } from "theme";
// import Layout from "scenes/layout";
// import Dashboard from "scenes/dashboard";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

// import Trips from "scenes/trips";
import { useTranslation } from "react-i18next";
// import TripInfo from "scenes/tripInfo";
// import TripReservations from "scenes/tripReservation";
// import AddTrip from "scenes/addTrip";
// import SearchTrip from "scenes/searchTrip";
// import SearchReservation from "scenes/searchReservation";
// import Login from "scenes/loginPage";
// import TripList from "scenes/tripList";
// import TripListInfo from "scenes/tripListInfo";
// import LoginAdmin from "scenes/admin/login";
// import AdminDashboard from "scenes/admin/adminDashboard";
// import AdminLayout from "scenes/admin/adminLayout";
// import AddBus from "scenes/admin/addBus";
// import AddDriver from "scenes/addDriver";
// import AddAssistant from "scenes/addAssisstant";
// import EditSingleTrip from "scenes/editSingleTrip";
// import GetClaims from "scenes/admin/getClaims";
// import GetCompanies from "scenes/admin/getCompanies";
// import AddCompany from "scenes/admin/addCompany";
// import GetCompanyUser from "scenes/getCompanyUser";
// import AddCompanyUser from "scenes/addCompanyUser";
import { decodeToken } from "react-jwt";
import Lottie from "react-lottie";
import busLoading from "lotties/bus_load.json";
import AddCity from "scenes/admin/addCity";
import { setCookie, getCookie, eraseCookie } from "./utils/helperFunction";
import GetUsers from "scenes/admin/getUsers";

// import EditParameters from "scenes/admin/editParameters";
// import EditGatewaysStatus from "scenes/admin/editGatewaysStatus";
// import EditCompany from "scenes/admin/editCompany";
// import EditCompanyUser from "scenes/editCompanyUser";

const LoginAdmin = lazy(() => import("scenes/admin/login"));
const AdminDashboard = lazy(() => import("scenes/admin/adminDashboard"));
const AdminLayout = lazy(() => import("scenes/admin/adminLayout"));
const AddBus = lazy(() => import("scenes/admin/addBus"));
const GetClaims = lazy(() => import("scenes/admin/getClaims"));
const GetCompanies = lazy(() => import("scenes/admin/getCompanies"));
const AddCompany = lazy(() => import("scenes/admin/addCompany"));
const EditCompany = lazy(() => import("scenes/admin/editCompany"));
const EditParameters = lazy(() => import("scenes/admin/editParameters"));
const EditGatewaysStatus = lazy(() =>
  import("scenes/admin/editGatewaysStatus")
);
// const EditCompanyUser = lazy(() => import("scenes/editCompanyUser"));

// Lazily import the user components
const Login = lazy(() => import("scenes/loginPage"));
const Layout = lazy(() => import("scenes/layout"));
const Dashboard = lazy(() => import("scenes/dashboard"));
const Trips = lazy(() => import("scenes/trips"));
const GetCompanyUser = lazy(() => import("scenes/getCompanyUser"));
const AddCompanyUser = lazy(() => import("scenes/addCompanyUser"));
const EditCompanyUser = lazy(() => import("scenes/editCompanyUser"));
const TripInfo = lazy(() => import("scenes/tripInfo"));
const EditSingleTrip = lazy(() => import("scenes/editSingleTrip"));
const TripReservations = lazy(() => import("scenes/tripReservation"));
const AddDriver = lazy(() => import("scenes/addDriver"));
const AddAssistant = lazy(() => import("scenes/addAssisstant"));
const AddTrip = lazy(() => import("scenes/addTrip"));
const SearchTrip = lazy(() => import("scenes/searchTrip"));
const SearchReservation = lazy(() => import("scenes/searchReservation"));
const TripList = lazy(() => import("scenes/tripList"));
const TripListInfo = lazy(() => import("scenes/tripListInfo"));

function App() {
  // const handleBeforeUnload = () => {
  //   eraseCookie.remove('token');
  //   eraseCookie.remove('d_token');
  // };
  // window.addEventListener('beforeunload', handleBeforeUnload);
  // window.addEventListener("beforeunload", function(event) {
  //   // Check if the page is being closed
  //   console.log("🚀 ~ window.addEventListener ~ event.clientY:", event.clientY)
  //   this.window.location = `test/${event.clientY}`

  //   if (event.clientY !== undefined) {
  //     // Get the expiration time from sessionStorage
  //     const expiryTime = sessionStorage.getItem("token_expiry");
  
  //     if (expiryTime) {
  //       const currentTime = new Date().getTime();
  //       if (currentTime < parseInt(expiryTime)) {
  //         // Delete the cookie if the browser is closed within 5 hours
  //         document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  //         document.cookie = "image=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  //         document.cookie = "name_ar=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  //       }
  //     }else{
  //       document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  //       document.cookie = "image=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  //       document.cookie = "name_ar=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  //     }
  //   }
  // });
  
  const [t, i18n] = useTranslation();
  const mode = useSelector((state) => state.global.mode);
  const theme = useMemo(() => createTheme(themeSettings(mode)), [mode]);
  const isAuth = Boolean(useSelector((state) => state.global.token));
  const token = useSelector((state) => state.global.token);
  const isAdminAuth = Boolean(useSelector((state) => state.global.d_token));
  console.log("isAuth", isAuth);
  let decodedToken = null;
  if (token) {
    decodedToken = decodeToken(token) ?? null;
  }

  const isAll = Boolean(decodedToken?.roles?.includes("all"));
  const isCanReports = Boolean(decodedToken?.roles?.includes("reports"));
  const isCanControlTrips = Boolean(
    decodedToken?.roles?.includes("trips_control")
  );
  const isCanNotSeeReports = Boolean(
    decodedToken?.roles?.includes("without_reports")
  );

  const defaultOptionsSearch = {
    loop: true,
    autoplay: true,
    animationData: busLoading,
    rendererSettings: {
      preserveAspectRatio: "xMidYMid slice",
    },
  };

  const testObj = {
    isAll,
    isCanReports,
    isCanControlTrips,
    isCanNotSeeReports,
  };
  console.log("decode", testObj);
  const adminLayout = useMemo(() => {
    return (
      <AdminLayout>
        <Outlet />
      </AdminLayout>
    );
  }, []);

  // useEffect(() => {
  //   const clearLocalStorage = () => {
  //     localStorage.clear();
  //   };

  //   window.addEventListener('beforeunload', clearLocalStorage);

  //   return () => {
  //     window.removeEventListener('beforeunload', clearLocalStorage);
  //   };
  // }, []);
  const userLayout = useMemo(() => {
    return (
      <Layout>
        <Outlet />
      </Layout>
    );
  }, []);
  
  return (
    <div className="app" dir={i18n.language === "en" ? "ltr" : "rtl"}>
      <ToastContainer />
      <BrowserRouter>
        <ThemeProvider theme={theme}>
          <CssBaseline />

          <Routes>
            {/* Start Admin Routes */}
            <Route path="admin/login" element={<LoginAdmin />} />
            <Route
              path="admin/*"
              element={
                isAdminAuth ? adminLayout : <Navigate to="/admin/login" />
              }
            >
              <Route
                index
                element={
                  isAdminAuth ? (
                    <Navigate to="/admin/dashboard" replace />
                  ) : (
                    <Navigate to="/admin/login" replace />
                  )
                }
              />
              <Route
                path="dashboard"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <AdminDashboard />
                  </Suspense>
                }
              />
              
              <Route
                path="add_region"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <AddCity />
                  </Suspense>
                }
              />
              <Route
                path="add_bus"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <AddBus />
                  </Suspense>
                }
              />
              <Route
                path="get_claims"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <GetClaims />
                  </Suspense>
                }
              />
              <Route
                path="get_users"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <GetUsers />
                  </Suspense>
                }
              />
              <Route
                path="get_companies"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <GetCompanies />
                  </Suspense>
                }
              />
              <Route
                path="add_company"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <AddCompany />
                  </Suspense>
                }
              />
              <Route
                path="edit_company/:id"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <EditCompany />
                  </Suspense>
                }
              />
              <Route
                path="parameters"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <EditParameters />
                  </Suspense>
                }
              />
              <Route
                path="payment_gateways"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <EditGatewaysStatus />
                  </Suspense>
                }
              />
              {/* Add more admin routes as needed */}
            </Route>
            {/* End Admin Routes */}

            {/* Start User Routes */}
            <Route path="login" element={<Login />} />
            <Route
              path="/*"
              element={isAuth ? userLayout : <Navigate to="/login" />}
            >
              <Route
                index
                element={
                  isAuth ? (
                    <Navigate to="/dashboard" replace />
                  ) : (
                    <Navigate to="/login" replace />
                  )
                }
              />
              <Route
                path="dashboard"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <Dashboard />
                  </Suspense>
                }
              />
              <Route
                path="trips"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <Trips />
                  </Suspense>
                }
              />
              <Route
                path="get_company_user"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <GetCompanyUser />
                  </Suspense>
                }
              />
              <Route
                path="get_company_user/:id"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <EditCompanyUser />
                  </Suspense>
                }
              />
              <Route
                path="trips/:id"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <TripInfo />
                  </Suspense>
                }
              />
              <Route
                path="trips/edit/:id"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <EditSingleTrip />
                  </Suspense>
                }
              />
              <Route
                path="trips/reservation/:tripId"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <TripReservations />
                  </Suspense>
                }
              />
              <Route
                path="add_driver"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <AddDriver />
                  </Suspense>
                }
              />
              <Route
                path="add_user"
                element={
                  isAuth ? (
                    <Suspense
                      fallback={
                        <Box mx="auto" width="30%">
                          <Lottie
                            options={defaultOptionsSearch}
                            height={400}
                            width={400}
                          />
                        </Box>
                      }
                    >
                      <AddCompanyUser />
                    </Suspense>
                  ) : (
                    <Navigate to="/" />
                  )
                }
              />
              <Route
                path="add_assistant"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <AddAssistant />
                  </Suspense>
                }
              />
              <Route
                path="add_trip"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <AddTrip />
                  </Suspense>
                }
              />
              <Route
                path="search_trip"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <SearchTrip />
                  </Suspense>
                }
              />
              <Route
                path="search_reservation"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <SearchReservation />
                  </Suspense>
                }
              />
              <Route
                path="trip_list"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <TripList />
                  </Suspense>
                }
              />
              <Route
                path="trip_list/:id"
                element={
                  <Suspense
                    fallback={
                      <Box mx="auto" width="30%">
                        <Lottie
                          options={defaultOptionsSearch}
                          height={400}
                          width={400}
                        />
                      </Box>
                    }
                  >
                    <TripListInfo />
                  </Suspense>
                }
              />
              {/* Add more user routes as needed */}
            </Route>
            {/* End User Routes */}
          </Routes>
        </ThemeProvider>
      </BrowserRouter>
    </div>
  );
}

export default App;
