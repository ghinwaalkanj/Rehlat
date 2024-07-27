/* eslint-disable react-hooks/rules-of-hooks */
import React, { useState } from "react";
import { Formik } from "formik";
import * as yup from "yup";
import {
  Box,
  Button,
  Checkbox,
  FormControl,
  FormControlLabel,
  InputLabel,
  Modal,
  MenuItem,
  Select,
  TextField,
  Typography,
  useMediaQuery,
  useTheme,
  useThemeProps,
} from "@mui/material";
import { useTranslation } from "react-i18next";
import {
  useGetCitiesQuery,
  useAddDriverMutation,
  useDeleteDriverMutation,
  useUpdateDriverMutation,
  useAddCityMutation,
} from "state/api";
import { DataGrid } from "@mui/x-data-grid";
const AddCity = () => {
  const [t, i18n] = useTranslation();

  const { palette } = useTheme();
  const theme = useTheme();
  const [isSearchLoading, setIsSearchLoading] = useState(false);
  const initialValuesRegister = {
    name_ar: "",
    name_en: "",
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

  const isNonMobile = useMediaQuery("(min-width:600px)");
  const { data, isLoading } = useGetCitiesQuery();
  const [addCity, { isLoading: isAddCityLoading }] = useAddCityMutation();

  const [page, setPage] = useState(0);
  const handleFormSubmit = async (values, onSubmitProps) => {
    await addCity(values);
    // console.log("data", data.results);;
    onSubmitProps.resetForm();
  };
  const [openReservation, setOpenReservation] = React.useState(false);
  const [openEditDriver, setOpenEditDriver] = React.useState(false);
  const [driverForUpdate, setDriverForUpdate] = useState({});
  const handleConfirmClose = () => setOpenReservation(false);
  const handleEditDriverClose = () => setOpenEditDriver(false);
  const [idToDelete, setIdToDelete] = useState(null);
  const styleModal = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 400,
    bgcolor: "background.paper",
    border: "2px solid #000",
    // boxShadow: 24,
    p: 4,
  };
  // const onConfirmClicked = async () => {
  //   await deleteDriver(idToDelete);
  //   setOpenReservation(false);
  // };
  // const onConfirmEditDriverClicked = async () => {
  //   const toEdit = {
  //     id: driverForUpdate.id,
  //     name: driverForUpdate.name,
  //     phone: driverForUpdate.phone,
  //   };
  //   await updateDriver(toEdit);
  //   setOpenEditDriver(false);
  // };
  const columns = [
    {
      field: "name_ar",
      headerName: " الاسم بالعربي",
      flex: 1,
    },
    {
      field: "name_en",
      headerName: " الاسم بالانكليزي",
      flex: 1,
    },

    // {
    //   field: "actions",
    //   headerName: "Actions",
    //   width: 180,
    //   renderCell: (params) => (
    //     <div>
    //       <Box
    //         display="inline-block"
    //         sx={{
    //           "& .MuiButton-outlined": {
    //             borderColor: theme.palette.secondary[300] + "!important",
    //             color: theme.palette.secondary[300],
    //           },
    //         }}
    //       >
    //         <Button
    //           sx={{ marginLeft: "12px" }}
    //           onClick={() => {
    //             const newObj = {
    //               id: params.id,
    //               name: params.row.name,
    //               phone: params.row.phone,
    //             };
    //             setDriverForUpdate(newObj);
    //             setOpenEditDriver(true);
    //           }}
    //           variant="outlined"
    //         >
    //           تعديل
    //         </Button>
    //       </Box>

    //       <Button
    //         variant="outlined"
    //         onClick={() => {
    //           setIdToDelete(params.id);
    //           setOpenReservation(true);
    //         }}
    //         color="error"
    //       >
    //         {t("delete")}
    //       </Button>
    //     </div>
    //   ),
    // },
  ];
  return (
    <div>
      {/* <Modal
        open={openReservation}
        onClose={handleConfirmClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <div>
          <Box sx={styleModal}>
            <Typography
              sx={{ mb: "2rem" }}
              id="modal-modal-title"
              variant="h6"
              component="h2"
            >
              Are you sure delete this driver?
            </Typography>

            <Button color="success" onClick={handleConfirmClose}>
              Close
            </Button>
            <Button color="error" onClick={onConfirmClicked}>
              Delete
            </Button>
          </Box>
        </div>
      </Modal> */}
      {/* update driver */}
      {/* <Modal
        open={openEditDriver}
        onClose={handleEditDriverClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <div>
          <Box sx={styleModal}>
            <Typography
              sx={{ mb: "2rem" }}
              id="modal-modal-title"
              variant="h6"
              component="h2"
            >
              تعديل معلومات السائق
            </Typography>
            <TextField
              fullWidth
              label=" اسم السائق"
              // onBlur={handleBlur}
              onChange={(e) => {
                const newObj = {
                  ...driverForUpdate,
                  name: e.target.value,
                };
                setDriverForUpdate(newObj);
              }}
              value={driverForUpdate.name}
              name="name"
              required={true}
              // error={Boolean(touched.name) && Boolean(errors.name)}
              // helperText={touched.name && errors.name}
              sx={{ mb: "1.3rem" }}
            />
            <TextField
              fullWidth
              label="رقم الهاتف"
              // onBlur={handleBlur}
              onChange={(e) => {
                console.log("dddd", e.target.value);
                const newObj = {
                  ...driverForUpdate,
                  phone: e.target.value,
                };
                setDriverForUpdate(newObj);
              }}
              value={driverForUpdate.phone}
              name="phone"
              required={true}
              // error={Boolean(touched.name) && Boolean(errors.name)}
              // helperText={touched.name && errors.name}
              sx={{ mb: "1.3rem" }}
            />
            <Button color="error" onClick={handleEditDriverClose}>
              Close
            </Button>
            <Button color="success" onClick={onConfirmEditDriverClicked}>
              update
            </Button>
          </Box>
        </div>
      </Modal> */}

      <Box m="10% 15% 5%">
        <Typography sx={{ mb: "2rem" }} variant="h3">
          إضافة منطقة
        </Typography>
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
                    {/* <DemoItem label="Mobile variant"> */}
                    <Box sx={{ gridColumn: "span 4" }}>
                      <Box
                        display="flex"
                        alignItems="center"
                        width="100%"
                        gap="2rem"
                      >
                        <Box width="100%">
                          <TextField
                            fullWidth
                            label=" ادخل اسم المنطقة بالعربي"
                            onBlur={handleBlur}
                            onChange={handleChange}
                            value={values.name_ar}
                            name="name_ar"
                            error={
                              Boolean(touched.name_ar) &&
                              Boolean(errors.name_ar)
                            }
                            helperText={touched.name_ar && errors.name_ar}
                            sx={{ gridColumn: "span 4" }}
                          />
                        </Box>
                      </Box>
                    </Box>
                    <Box sx={{ gridColumn: "span 4" }}>
                      <Box
                        display="flex"
                        alignItems="center"
                        width="100%"
                        gap="2rem"
                      >
                        <Box width="100%">
                          <TextField
                            fullWidth
                            label=" ادخل اسم المنطقة بالانكليزي"
                            onBlur={handleBlur}
                            onChange={handleChange}
                            value={values.name_en}
                            name="name_en"
                            error={
                              Boolean(touched.name_en) &&
                              Boolean(errors.name_en)
                            }
                            helperText={touched.name_en && errors.name_en}
                            sx={{ gridColumn: "span 4" }}
                          />
                        </Box>
                      </Box>
                    </Box>
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
                  {t("اضافة")}
                </Button>
              </Box>
            </form>
          )}
        </Formik>
        {/* {isSearchLoading && (
        // <Lottie
        //   options={defaultOptionsSearch}
        //   height={400}
        //   width={400}
        //   // isStopped={this.state.isStopped}
        //   // isPaused={this.state.isPaused}
        // />
      )} */}
      </Box>

      {/* {searchResults && searchResults.length > 0 && (
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
        /> */}
      {/* </Box>
    )} */}

      <Box m="0.5rem 0.5rem">
        {/* <Header title="الرحلات" subtitle="قائمة الرحلات القادمة"  /> */}
        <Typography
          sx={{ textAlign: "center", marginBottom: "1rem" }}
          variant="h4"
        >
          المضافة مسبقاََ
        </Typography>
        <Box
          height="80vh"
          sx={{
            "& .MuiDataGrid-root": {
              border: "none",
              fontSize:"16px"
            },
            "& .MuiDataGrid-cell": {
              borderBottom: `1px solid ${theme.palette.secondary[50]}`,
              fontSize:"16px"
            },
            "& .MuiDataGrid-columnHeaders": {
              backgroundColor: theme.palette.background.alt,
              color: theme.palette.secondary[50],
              borderBottom: "none",
            },
            "& .MuiDataGrid-virtualScroller": {
              backgroundColor: theme.palette.primary.light,
              fontSize:"16px"
            },
            "& .MuiDataGrid-footerContainer": {
              backgroundColor: theme.palette.background.alt,
              color: theme.palette.secondary[50],
              fontSize:"16px",
              borderTop: "none",
            },
            "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
              color: `${theme.palette.secondary[200]} !important`,
              fontSize:"16px"
            },
          }}
        >
          {console.log("dd", data)}
          <DataGrid
            loading={!data}
            getRowId={(row) => row.id}
            rows={(data?.data?.cities && data?.data?.cities) || []}
            columns={columns}
            rowCount={(data?.data?.cities && data?.data?.cities?.length) || 0}
            rowsPerPageOptions={[20, 50, 100]}
            page={page}
            onPageChange={(newPage) => setPage(newPage)}
          />
        </Box>
      </Box>
    </div>
  );
};

export default AddCity;
