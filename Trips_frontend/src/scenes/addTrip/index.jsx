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
import { Formik } from "formik";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DatePicker, LocalizationProvider } from "@mui/x-date-pickers";
import * as yup from "yup";
import React, { useEffect } from "react";
import {
  useGetAssistantsQuery,
  useGetCitiesQuery,
  useGetDriversQuery,
} from "state/api";
import { MobileDateTimePicker } from "@mui/x-date-pickers/MobileDateTimePicker";
import { useTripListMutation, useGetBusesQuery } from "state/api";

import dayjs from "dayjs";
import { MobileTimePicker } from "@mui/x-date-pickers";
import { useTranslation } from "react-i18next";
import { toast } from "react-toastify";
const AddTrip = () => {
  const { palette } = useTheme();
  const [t, i18n] = useTranslation();
  const currentDateTime = dayjs();
  const dateTimeAt1530 = currentDateTime.set("hour", 15).set("minute", 30);
  const endDateTime = dateTimeAt1530.add(1, "day");
  const initialValuesRegister = {
    source_city_id: "",
    destination_city_id: "",
    ticketPrice: "",
    percentage_price: "",
    bus_id: "",
    driver_id: "",
    driver_assistant_id: "",
    dateTime: dateTimeAt1530,
    endDateTime: endDateTime,
    daysOfWeek: [],
  };
  const registerSchema = yup.object().shape({
    source_city_id: yup.string().required("required"),
    destination_city_id: yup.string().required("required"),
    ticketPrice: yup.string().required("required"),
    bus_id: yup.number().required("required"),
    driver_id: yup.number().required("required"),
    driver_assistant_id: yup.number().required("required"),
    percentage_price: yup.number().required("required"),
    daysOfWeek: yup.array(),
    //.min(1, "Select at least one day")
  });
  const [createTripList, { isSuccess, isError, error }] = useTripListMutation();

  const initialValuesLogin = {
    username: "",
    password: "",
  };
  const isNonMobile = useMediaQuery("(min-width:600px)");
  const { data, isLoading } = useGetCitiesQuery();
  const { data: dataBuses } = useGetBusesQuery();
  const { data: dataDrivers } = useGetDriversQuery();
  const { data: dataAssistants } = useGetAssistantsQuery();
  console.log("d", data?.data?.cities);
  const [selectedOption, setSelectedOption] = React.useState("once");
  const handleFormSubmit = async (values, onSubmitProps) => {
    if (values.destination_city_id === values.source_city_id) {
      toast.error("لايمكن ان تكون الوجهة مثل الانطلاق");
    } else {
      console.log("values", values);
      values.start_date = values.dateTime;
      values.end_date = values.endDateTime;
      values.type = selectedOption;
      await createTripList(values);
      console.log("eee", error);
      toast.success("تمت العملية بنجاح");
      onSubmitProps.resetForm();
    }
  };

  const label = { inputProps: { "aria-label": "Checkbox demo" } };
  const days = [
    { label: "Sunday", value: 1 },
    { label: "Monday", value: 2 },
    { label: "Tuesday", value: 3 },
    { label: "Wednesday", value: 4 },
    { label: "Thursday", value: 5 },
    { label: "Friday", value: 6 },
    { label: "Saturday", value: 7 },
  ];
  const handleAllChange = (isChecked, setFieldValue) => {
    const allDays = days.map((day) => day.value);

    setFieldValue("daysOfWeek", isChecked ? allDays : []);
  };

  return (
    <div>
      <Box m="6rem">
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
                        {/* <MenuItem value="">الانطلاق</MenuItem> */}
                        {data?.data?.cities.map((city) => (
                          <MenuItem key={city.id} value={city.id}>
                            {city.name_ar}
                          </MenuItem>
                        ))}

                        {/* Add more MenuItem components for your options */}
                      </Select>
                      {touched.source_city_id && errors.source_city_id && (
                        <div className="error-message">
                          {errors.source_city_id}
                        </div>
                      )}
                    </FormControl>
                    <FormControl sx={{ gridColumn: "span 2" }}>
                      <InputLabel id="location-label">
                        {t("destination")}
                      </InputLabel>
                      <Select
                        labelId="location-label"
                        id="location"
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

                        {/* Add more MenuItem components for your options */}
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
                          {/* <Typography variant="h5">{t('start_time')}</Typography> */}
                          <LocalizationProvider dateAdapter={AdapterDayjs}>
                            <MobileTimePicker
                              //   ampm={false}
                              sx={{
                                flexBasis: "100%",
                              }}
                              //   defaultValue={dayjs("2022-04-17T15:30")}
                              // defaultValue={dayjs().format("HH:mm")}
                              value={values.dateTime}
                              //   onChange={handleChange}
                              onChange={(v) => {
                                values.dateTime = v;
                              }}
                            />
                          </LocalizationProvider>
                        </Box>
                        {/* <Typography variant="h5">تاريخ الانطلاق</Typography> */}
                        <Box width="100%">
                          <FormControl fullWidth>
                            <InputLabel id="location-label">
                              {t("الباص")}
                            </InputLabel>
                            <Select
                              labelId="location-label"
                              id="location"
                              name="bus_id"
                              value={values.bus_id}
                              onChange={handleChange}
                              onBlur={handleBlur}
                              error={
                                Boolean(touched.bus_id) &&
                                Boolean(errors.bus_id)
                              }
                            >
                              {/* <MenuItem value="">الانطلاق</MenuItem> */}
                              {dataBuses?.data?.buses.map((bus) => (
                                <MenuItem key={bus.id} value={bus.id}>
                                  {bus.details}
                                </MenuItem>
                              ))}
                              {/* <MenuItem value="1">VIP</MenuItem>
                              <MenuItem value="2">Normal</MenuItem>
                              <MenuItem value="3">Small</MenuItem> */}

                              {/* Add more MenuItem components for your options */}
                            </Select>
                            {touched.bus_id && errors.bus_id && (
                              <div className="error-message">
                                {errors.bus_id}
                              </div>
                            )}
                          </FormControl>
                        </Box>
                      </Box>
                    </Box>
                    {/* </DemoItem> */}
                    {/* driver  */}
                    <Box sx={{ gridColumn: "span 4" }}>
                      <Box
                        display="flex"
                        alignItems="center"
                        width="100%"
                        gap="2rem"
                      >
                        <Box width="100%">
                          <FormControl fullWidth>
                            <InputLabel id="location-label">
                              {t("السائق")}
                            </InputLabel>
                            <Select
                              labelId="location-label"
                              id="location"
                              name="driver_id"
                              value={values.driver_id}
                              onChange={handleChange}
                              onBlur={handleBlur}
                              error={
                                Boolean(touched.driver_id) &&
                                Boolean(errors.driver_id)
                              }
                            >
                              {/* <MenuItem value="">الانطلاق</MenuItem> */}
                              {dataDrivers?.data?.drivers.map((driver) => (
                                <MenuItem key={driver.id} value={driver.id}>
                                  {driver.name}
                                </MenuItem>
                              ))}
                              {/* <MenuItem value="1">VIP</MenuItem>
                              <MenuItem value="2">Normal</MenuItem>
                              <MenuItem value="3">Small</MenuItem> */}

                              {/* Add more MenuItem components for your options */}
                            </Select>
                            {touched.driver_id && errors.driver_id && (
                              <div className="error-message">
                                {errors.driver_id}
                              </div>
                            )}
                          </FormControl>
                        </Box>
                        {/* <Typography variant="h5">تاريخ الانطلاق</Typography> */}
                        <Box width="100%">
                          <FormControl fullWidth>
                            <InputLabel id="location-label">
                              {t("مساعد السائق")}
                            </InputLabel>
                            <Select
                              labelId="location-label"
                              id="location"
                              name="driver_assistant_id"
                              value={values.driver_assistant_id}
                              onChange={handleChange}
                              onBlur={handleBlur}
                              error={
                                Boolean(touched.driver_assistant_id) &&
                                Boolean(errors.driver_assistant_id)
                              }
                            >
                              {/* <MenuItem value="">الانطلاق</MenuItem> */}
                              {dataAssistants?.data?.drivers_assistant.map(
                                (assistant) => (
                                  <MenuItem
                                    key={assistant.id}
                                    value={assistant.id}
                                  >
                                    {assistant.name}
                                  </MenuItem>
                                )
                              )}
                              {/* <MenuItem value="1">VIP</MenuItem>
                              <MenuItem value="2">Normal</MenuItem>
                              <MenuItem value="3">Small</MenuItem> */}

                              {/* Add more MenuItem components for your options */}
                            </Select>
                            {touched.driver_assistant_id &&
                              errors.driver_assistant_id && (
                                <div className="error-message">
                                  {errors.driver_assistant_id}
                                </div>
                              )}
                          </FormControl>
                        </Box>
                      </Box>
                    </Box>
                    {/*  */}
                    <TextField
                      label={t("ticket_price")}
                      onBlur={handleBlur}
                      onChange={handleChange}
                      value={values.ticketPrice}
                      name="ticketPrice"
                      error={
                        Boolean(touched.ticketPrice) &&
                        Boolean(errors.ticketPrice)
                      }
                      helperText={touched.ticketPrice && errors.ticketPrice}
                      sx={{ gridColumn: "span 2" }}
                    />
                    <TextField
                      label="النسبة المضافة"
                      onBlur={handleBlur}
                      onChange={handleChange}
                      type="number"
                      value={values.percentage_price}
                      name="percentage_price"
                      error={
                        Boolean(touched.percentage_price) &&
                        Boolean(errors.percentage_price)
                      }
                      helperText={
                        touched.percentage_price && errors.percentage_price
                      }
                      sx={{ gridColumn: "span 2" }}
                    />

                    <Box gridColumn="span 3">
                      <Box display="flex" gap="3rem">
                        <label>
                          <input
                            type="radio"
                            value="once"
                            checked={selectedOption === "once"}
                            onChange={() => setSelectedOption("once")}
                          />
                          Once
                        </label>

                        <label>
                          <input
                            type="radio"
                            value="specificPeriod"
                            checked={selectedOption === "specificPeriod"}
                            onChange={() => setSelectedOption("specificPeriod")}
                          />
                          Specific Period
                        </label>

                        <label>
                          <input
                            type="radio"
                            value="unlimited"
                            checked={selectedOption === "unlimited"}
                            onChange={() => setSelectedOption("unlimited")}
                          />
                          Unlimited
                        </label>
                      </Box>
                      <Box
                        width="100%"
                        display="flex"
                        justifyContent="flex-start"
                        mt="3rem"
                      >
                        {selectedOption === "once" && (
                          <div>
                            {/* Render your day selection options here */}
                            <p>Choose the day:</p>
                            <Box
                              width="100%"
                              display="flex"
                              alignItems="center"
                            >
                              <LocalizationProvider dateAdapter={AdapterDayjs}>
                                <DatePicker
                                  sx={{
                                    flexBasis: "100%",
                                  }}
                                  value={values.dateTime}
                                  onChange={(v) => {
                                    values.dateTime = v;
                                  }}
                                />
                              </LocalizationProvider>
                            </Box>

                            {/* Place your day selection UI elements here */}
                          </div>
                        )}

                        {selectedOption === "specificPeriod" && (
                          <div>
                            {/* Render your specific period selection options here */}
                            <p>Choose the start and end date:</p>
                            <Box
                              width="100%"
                              display="flex"
                              alignItems="center"
                            >
                              <Box display="flex" flexDirection="column">
                                <Typography variant="h5">
                                  تاريخ البداية :{" "}
                                </Typography>
                                <LocalizationProvider
                                  dateAdapter={AdapterDayjs}
                                >
                                  <DatePicker
                                    sx={{
                                      flexBasis: "100%",
                                      ml: "2rem",
                                    }}
                                    value={values.dateTime}
                                    onChange={(v) => {
                                      values.dateTime = v;
                                    }}
                                  />
                                </LocalizationProvider>
                              </Box>
                              <Box display="flex" flexDirection="column">
                                <Typography variant="h5">
                                  تاريخ الانتهاء :{" "}
                                </Typography>
                                <LocalizationProvider
                                  dateAdapter={AdapterDayjs}
                                >
                                  <DatePicker
                                    sx={{
                                      flexBasis: "100%",
                                    }}
                                    value={values.endDateTime}
                                    onChange={(v) => {
                                      values.endDateTime = v;
                                    }}
                                  />
                                </LocalizationProvider>
                              </Box>
                            </Box>
                            <p>Choose the days:</p>
                            <FormControlLabel
                              control={
                                <Checkbox
                                  onChange={(e) =>
                                    handleAllChange(
                                      e.target.checked,
                                      setFieldValue
                                    )
                                  }
                                  checked={
                                    values.daysOfWeek.length === days.length
                                  }
                                  color="primary"
                                />
                              }
                              label="All"
                            />
                            {days.map((day) => (
                              <FormControlLabel
                                key={day.value}
                                control={
                                  <Checkbox
                                    name="daysOfWeek"
                                    value={day.value}
                                    checked={values.daysOfWeek.includes(
                                      day.value
                                    )}
                                    onChange={(e) => {
                                      const value = day.value;
                                      const isChecked = e.target.checked;
                                      setFieldValue(
                                        "daysOfWeek",
                                        isChecked
                                          ? [...values.daysOfWeek, value]
                                          : values.daysOfWeek.filter(
                                              (d) => d !== value
                                            )
                                      );
                                    }}
                                    color="primary"
                                  />
                                }
                                label={day.label}
                                sx={{ gridColumn: "span 2" }}
                              />
                            ))}
                            {Boolean(touched.daysOfWeek) &&
                              Boolean(errors.daysOfWeek) && (
                                <Box color="red">{errors.daysOfWeek}</Box>
                              )}
                          </div>
                        )}

                        {selectedOption === "unlimited" && (
                          <div>
                            {/* Render your unlimited selection options here */}
                            <p>Choose the days:</p>
                            <FormControlLabel
                              control={
                                <Checkbox
                                  onChange={(e) =>
                                    handleAllChange(
                                      e.target.checked,
                                      setFieldValue
                                    )
                                  }
                                  checked={
                                    values.daysOfWeek.length === days.length
                                  }
                                  color="primary"
                                />
                              }
                              label="All"
                            />

                            {days.map((day) => (
                              <FormControlLabel
                                key={day.value}
                                control={
                                  <Checkbox
                                    name="daysOfWeek"
                                    value={day.value}
                                    checked={values.daysOfWeek.includes(
                                      day.value
                                    )}
                                    onChange={(e) => {
                                      const value = day.value;
                                      const isChecked = e.target.checked;
                                      setFieldValue(
                                        "daysOfWeek",
                                        isChecked
                                          ? [...values.daysOfWeek, value]
                                          : values.daysOfWeek.filter(
                                              (d) => d !== value
                                            )
                                      );
                                    }}
                                    color="primary"
                                  />
                                }
                                label={day.label}
                                sx={{ gridColumn: "span 2" }}
                              />
                            ))}
                            {Boolean(touched.daysOfWeek) &&
                              Boolean(errors.daysOfWeek) && (
                                <Box color="red">{errors.daysOfWeek}</Box>
                              )}
                          </div>
                        )}
                      </Box>
                    </Box>
                    {/* <Box gridColumn="span 2">
                      {days.map((day) => (
                        <FormControlLabel
                          key={day.value}
                          control={
                            <Checkbox
                              name="daysOfWeek"
                              value={day.value}
                              checked={values.daysOfWeek.includes(day.value)}
                              onChange={(e) => {
                                const value = day.value;
                                const isChecked = e.target.checked;
                                setFieldValue(
                                  "daysOfWeek",
                                  isChecked
                                    ? [...values.daysOfWeek, value]
                                    : values.daysOfWeek.filter(
                                        (d) => d !== value
                                      )
                                );
                              }}
                              color="primary"
                            />
                          }
                          label={day.label}
                          sx={{ gridColumn: "span 2" }}
                        />
                      ))}
                      {Boolean(touched.daysOfWeek) &&
                        Boolean(errors.daysOfWeek) && (
                          <Box color="red">{errors.daysOfWeek}</Box>
                        )}
                    </Box> */}
                    <Box
                      gridColumn="span 4"
                      border={`1px solid ${palette.neutral.medium}`}
                      borderRadius="5px"
                      p="1rem"
                    ></Box>
                  </>
                }
              </Box>

              {/* BUTTONS */}
              <Box>
                <Button
                  fullWidth
                  type="submit"
                  sx={{
                    m: "2rem 0",
                    p: "1rem",
                    backgroundColor: palette.secondary[300],
                    color: palette.background.alt,
                    ":hover": {
                      bgcolor: "primary.main", // theme.palette.primary.main
                      color: "white",
                    },
                  }}
                >
                  {t("add_trip")}
                </Button>
              </Box>
            </form>
          )}
        </Formik>
      </Box>
    </div>
  );
};

export default AddTrip;
