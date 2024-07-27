/* eslint-disable react-hooks/rules-of-hooks */
import React from "react";
import { Formik } from "formik";
import * as yup from "yup";
import {
  Box,
  Button,
  Checkbox,
  FormControl,
  FormControlLabel,
  InputLabel,
  MenuItem,
  Select,
  TextField,
  Typography,
  useMediaQuery,
  useTheme,
} from "@mui/material";
import dayjs from "dayjs";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DatePicker, LocalizationProvider } from "@mui/x-date-pickers";
import { useGetCitiesQuery, useSearchTripQuery } from "state/api";
import { decodeToken } from "react-jwt";
import { useEffect } from "react";
import { useState } from "react";
import ResultSearch from "./resultSearch";
import axios from "axios";
import Lottie from "react-lottie";
import animationData from "lotties/animation_lmtdnv9x.json";
import animationSearch from "lotties/animation_search2.json";
import { useTranslation } from "react-i18next";
import { useSelector } from "react-redux";
import { getCookie } from "utils/helperFunction";
// import { useQueryClient } from "@reduxjs/toolkit/query/react";

// import { useQueryClient } from "@reduxjs/toolkit/query/react"; // Import useQueryClient

const SearchTrip = () => {
  const [t, i18n] = useTranslation();
  const token = useSelector((state) => state.global.token);

  let decodedToken = null;
  if (token) {
    decodedToken = decodeToken(token) ?? null;
  }
  const isCanPayment = Boolean(
    decodedToken?.roles?.includes("payment")
  );
  const defaultOptions = {
    loop: true,
    autoplay: true,
    animationData: animationData,
    rendererSettings: {
      preserveAspectRatio: "xMidYMid slice",
    },
  };
  const defaultOptionsSearch = {
    loop: true,
    autoplay: true,
    animationData: animationSearch,
    rendererSettings: {
      preserveAspectRatio: "xMidYMid slice",
    },
  };

  const { palette } = useTheme();
  const [isSearchLoading, setIsSearchLoading] = useState(false);
  const initialValuesRegister = {
    source_city_id: "",
    destination_city_id: "",
    tripNumber: "",
    bus_type: "",
    dateTime: null,
    daysOfWeek: [],
  };
  // const queryClient = useQueryClient();

  const registerSchema = yup.object().shape({
    // source_city_id: yup.string().required("required"),
    // destination_city_id: yup.string().required("required"),
    // tripNumber: yup.string().required("required"),
    // bus_type: yup.string().required("required"),
    // daysOfWeek: yup
    //   .array()
    //   .min(1, "Select at least one day")
    //   .required("required"),
  });
  const globalSuccess = false;
  const [searchResults, setSearchResults] = useState(null);
  // const queryClient = useQueryClient(); // Initialize the query client

  useEffect(() => {
    if (globalSuccess) {
      console.log("success");
    }
  }, [globalSuccess]);
  // const [createTripList, { isSuccess }] = useTripListMutation();

  const initialValuesLogin = {
    username: "",
    password: "",
  };
  const isNonMobile = useMediaQuery("(min-width:600px)");
  const { data, isLoading } = useGetCitiesQuery();
  const tokenFind = getCookie("token");
  const handleFormSubmit = async (values, onSubmitProps) => {
    console.log("values", values);
    if (values.dateTime) {
      values.dateTime = dayjs(values.dateTime).format("YYYY-MM-DDTHH:mm:ssZ");
    }
    // const { data } = await useSearchTripQuery(values).unwrapOr({ data: [] });

    setIsSearchLoading(true);
    const { data } = await axios.get(
      process.env.REACT_APP_BASE_URL + "trip/find",
      {
        params: values,
        headers: {
          Authorization: `Bearer ${tokenFind}`,
        },
      }
    );
    setIsSearchLoading(false);
    // await queryClient.fetchQuery(["searchTrip"], useSearchTripQuery(values));

    console.log("data", data.results);
    setSearchResults(data?.results); // Set the search results in state

    onSubmitProps.resetForm();
  };
  return (
    <div>
      <Box m="10% 15% 5%">
        <Formik
          onSubmit={handleFormSubmit}
          initialValues={initialValuesRegister}
          validationSchema={registerSchema}
        >
          {({
            values,
            errors,
            touched,
            handleBlur,
            handleChange,
            handleSubmit,
            setFieldValue,
            resetForm,
            dirty,
          }) => (
            <form onSubmit={handleSubmit}>
              {console.log("values", values)}
              <Box
                display="grid"
                gap="30px"
                gridTemplateColumns="repeat(4, minmax(0, 1fr))"
                sx={{
                  "& > div": { gridColumn: isNonMobile ? undefined : "span 4" },
                }}
              >
                {
                  <>
                    <FormControl sx={{ gridColumn: "span 2" }}>
                      <InputLabel id="location-label">{t("source")}</InputLabel>
                      <Select
                        labelId="location-label"
                        id="location"
                        name="source_city_id"
                        value={values.source_city_id}
                        onChange={handleChange}
                        onBlur={handleBlur}
                        error={
                          Boolean(touched.source_city_id) &&
                          Boolean(errors.source_city_id)
                        }
                      >
                        {data?.data?.cities.map((city) => (
                          <MenuItem key={city.id} value={city.id}>
                            {city.name_ar}
                          </MenuItem>
                        ))}
                      </Select>
                      {touched.source_city_id && errors.source_city_id && (
                        <div className="error-message">
                          {errors.source_city_id}
                        </div>
                      )}
                    </FormControl>
                    <FormControl sx={{ gridColumn: "span 2" }}>
                      <InputLabel id="destination-label">
                        {t("destination")}
                      </InputLabel>
                      <Select
                        labelId="destination-label"
                        id="destination"
                        name="destination_city_id"
                        value={values.destination_city_id}
                        onChange={handleChange}
                        onBlur={handleBlur}
                        error={
                          Boolean(touched.destination_city_id) &&
                          Boolean(errors.destination_city_id)
                        }
                      >
                        {/* <MenuItem value="">الانطلاق</MenuItem> */}
                        {data?.data?.cities.map((city) => (
                          <MenuItem key={city.id} value={city.id}>
                            {city.name_ar}
                          </MenuItem>
                        ))}
                      </Select>
                      {touched.destination_city_id &&
                        errors.destination_city_id && (
                          <div className="error-message">
                            {errors.destination_city_id}
                          </div>
                        )}
                    </FormControl>
                    {/* <DemoItem label="Mobile variant"> */}
                    <Box sx={{ gridColumn: "span 4" }}>
                      <Box
                        display="flex"
                        alignItems="center"
                        width="100%"
                        gap="2rem"
                      >
                        <Box width="100%" display="flex" alignItems="center">
                          <LocalizationProvider dateAdapter={AdapterDayjs}>
                            <DatePicker
                              sx={{
                                flexBasis: "100%",
                              }}
                              value={values.dateTime}
                              onChange={(v) => setFieldValue("dateTime", v)}
                            />
                          </LocalizationProvider>
                        </Box>
                        <Box width="100%">
                          <TextField
                            fullWidth
                            label={t("trip_number")}
                            onBlur={handleBlur}
                            onChange={handleChange}
                            value={values.tripNumber}
                            name="tripNumber"
                            error={
                              Boolean(touched.tripNumber) &&
                              Boolean(errors.tripNumber)
                            }
                            helperText={touched.tripNumber && errors.tripNumber}
                            sx={{ gridColumn: "span 4" }}
                          />
                        </Box>
                      </Box>
                    </Box>
                    {/* </DemoItem> */}

                    {/* <Box
                      gridColumn="span 4"
                      border={`1px solid ${palette.neutral.medium}`}
                      borderRadius="5px"
                      p="1rem"
                    ></Box> */}
                  </>
                }
              </Box>

              {/* BUTTONS */}
              <Box>
                <Button
                  fullWidth
                  type="submit"
                  // disabled={!dirty}
                  sx={{
                    m: "2rem 0 0 0",
                    p: "1rem",
                    backgroundColor: palette.secondary[300],
                    color: palette.background.alt,
                    ":hover": {
                      bgcolor: "primary.main", // theme.palette.primary.main
                      color: "white",
                    },
                  }}
                >
                  {t("search")}
                </Button>
              </Box>
            </form>
          )}
        </Formik>
        {isSearchLoading && (
          <Lottie
            options={defaultOptionsSearch}
            height={400}
            width={400}
            // isStopped={this.state.isStopped}
            // isPaused={this.state.isPaused}
          />
        )}
      </Box>

      {searchResults && searchResults.length > 0 && (
        <ResultSearch searchData={searchResults} isCanPayment={isCanPayment} />
      )}
      {searchResults && !isSearchLoading && searchResults.length === 0 && (
        <Box>
          <Typography variant="h3" sx={{ textAlign: "center" }}>
            لاتوجد نتائج للبحث
          </Typography>
          <Lottie
            options={defaultOptions}
            height={400}
            width={400}
            // isStopped={this.state.isStopped}
            // isPaused={this.state.isPaused}
          />
        </Box>
      )}
    </div>
  );
};

export default SearchTrip;
