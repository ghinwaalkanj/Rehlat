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
import { useEffect } from "react";
import { useState } from "react";
import ResultSearch from "./resultSearch";
import axios from "axios";
import Lottie from "react-lottie";
import animationData from "lotties/animation_lmtdnv9x.json";
import animationSearch from "lotties/animation_search2.json";
import { useTranslation } from "react-i18next";
import { setCookie, getCookie, eraseCookie } from "../../utils/helperFunction";


const SearchReservation = () => {
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
  const registerSchema = yup.object().shape({});
  const { palette } = useTheme();
  const [isSearchLoading, setIsSearchLoading] = useState(false);
  const initialValuesRegister = {
    phoneNumber: "",
    reservationNumber: "",
  };
  const [t, i18n] = useTranslation();
  const [searchResults, setSearchResults] = useState(null);

  const isNonMobile = useMediaQuery("(min-width:600px)");
  const { data, isLoading } = useGetCitiesQuery();
  const token = getCookie("token");
  const handleFormSubmit = async (values, onSubmitProps) => {
    setIsSearchLoading(true);
    const { data } = await axios.get(
      process.env.REACT_APP_BASE_URL + "reservation/find",
      {
        params: values,
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    setIsSearchLoading(false);
    console.log("data", data.data);
    setSearchResults(data?.data?.reservations); // Set the search results in state
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
              {/* {console.log("values", values)} */}
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
                    <TextField
                      fullWidth
                      label={t("phone_number")}
                      onBlur={handleBlur}
                      onChange={handleChange}
                      value={values.phoneNumber}
                      name="phoneNumber"
                      error={
                        Boolean(touched.phoneNumber) &&
                        Boolean(errors.phoneNumber)
                      }
                      helperText={touched.phoneNumber && errors.phoneNumber}
                      sx={{ gridColumn: "span 4" }}
                    />
                    <TextField
                      fullWidth
                      label={t("reservation_number")}
                      onBlur={handleBlur}
                      onChange={handleChange}
                      value={values.reservationNumber}
                      name="reservationNumber"
                      error={
                        Boolean(touched.reservationNumber) &&
                        Boolean(errors.reservationNumber)
                      }
                      helperText={
                        touched.reservationNumber && errors.reservationNumber
                      }
                      sx={{ gridColumn: "span 4" }}
                    />
                  </>
                }
              </Box>

              {/* BUTTONS */}
              <Box>
                <Button
                  fullWidth
                  type="submit"
                  disabled={!dirty}
                  sx={{
                    m: "2rem 0 0 0",
                    p: "1rem",
                    backgroundColor: palette.secondary[300],
                    color: palette.background.alt,
                    ":hover": {
                      bgcolor: "primary.main", // theme.palette.primary.main
                      color: "white",
                    },
                    "&:disabled": {
                      color: "grey",
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
        <ResultSearch searchData={searchResults} />
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

export default SearchReservation;
