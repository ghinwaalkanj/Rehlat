import { Box, Button, Modal, Typography, useTheme } from "@mui/material";
import React, { useState } from "react";
import { DataGrid } from "@mui/x-data-grid";
import { useFinishTripListMutation, useGetTripListQuery } from "state/api";
import Header from "components/Header";
import DataGridCustomToolbar from "components/DataGridCustomToolbar";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { decodeToken } from "react-jwt";
import { useSelector } from "react-redux";
const TripList = () => {
  const token = useSelector((state) => state.global.token);

  let decodedToken = null;
  if (token) {
    decodedToken = decodeToken(token) ?? null;
  }

  const isAll = Boolean(decodedToken?.roles?.includes("all"));
  const isCanControlTrips = Boolean(
    decodedToken?.roles?.includes("trips_control")
  );
  const [t, i18n] = useTranslation();
  const theme = useTheme();
  const navigate = useNavigate();
  const { data, isLoading } = useGetTripListQuery();
  const [page, setPage] = useState(0);
  const [openReservation, setOpenReservation] = React.useState(false);
  const handleConfirmClose = () => setOpenReservation(false);
  const [idToDelete, setIdToDelete] = useState(null);
  const [
    cancelTrip,
    { data: dataCanceled, isSuccess, isLoading: isDeleteBusLoading, error },
  ] = useFinishTripListMutation();
  const onConfirmClicked = async () => {
    await cancelTrip(idToDelete);
    setOpenReservation(false);
  };
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
  const columns = [
    {
      field: "id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "source",
      headerName: "من",
      flex: 1,
    },
    {
      field: "destination",
      headerName: "إلى",
      flex: 1,
    },
    {
      field: "start_date",
      headerName: "موعد الرحلة",
      flex: 1,
      renderCell: (params) => {
        const dateTime = new Date(params.row.start_date);
        const hours = dateTime.getHours().toString().padStart(2, "0");
        const minutes = dateTime.getMinutes().toString().padStart(2, "0");
        // const seconds = dateTime.getSeconds().toString().padStart(2, "0");

        const timeString = `${hours}:${minutes}`;
        return <Box>{timeString}</Box>;
      },
    },
    {
      field: "bus_type",
      headerName: "نوع الباص",
      flex: 1,
    },
    {
      field: "rate",
      headerName: "التقييم",
      flex: 1,
    },
    {
      field: "actions",
      headerName: "Actions",
      width: 180,
      renderCell: (params) => (
        <div>
          <Box
            display="inline-block"
            sx={{
              "& .MuiButton-outlined": {
                borderColor: theme.palette.secondary[300] + "!important",
                color: theme.palette.secondary[300],
              },
            }}
          >
            <Button
              sx={{ marginLeft: "12px" }}
              onClick={() => navigate(`/trip_list/${params.id}`)}
              variant="outlined"
            >
              {t("show")}
            </Button>
          </Box>

          {(isAll || isCanControlTrips) && (
            <Button
              variant="outlined"
              onClick={() => {
                setIdToDelete(params.id);
                setOpenReservation(true);
              }}
              color="error"
            >
              انهاء
            </Button>
          )}
        </div>
      ),
    },
  ];

  return (
    <Box m="1.5rem 2.5rem">
      <Modal
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
              Are you sure delete this continue list?
            </Typography>

            <Button color="success" onClick={handleConfirmClose}>
              NO
            </Button>
            <Button color="error" onClick={onConfirmClicked}>
              Yes
            </Button>
          </Box>
        </div>
      </Modal>
      <Header title={t("trip_list")} />
      <Box
        height="80vh"
        sx={{
          "& .MuiDataGrid-root": {
            border: "none",
          },
          "& .MuiDataGrid-cell": {
            borderBottom: `1px solid ${theme.palette.secondary[50]}`,
          },
          "& .MuiDataGrid-columnHeaders": {
            backgroundColor: theme.palette.background.alt,
            color: theme.palette.secondary[50],
            borderBottom: "none",
            fontSize:"16px"
          },
          "& .MuiDataGrid-virtualScroller": {
            backgroundColor: theme.palette.primary.light,
          },
          "& .MuiDataGrid-footerContainer": {
            backgroundColor: theme.palette.background.alt,
            color: theme.palette.secondary[50],
            borderTop: "none",
          },
          "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
            color: `${theme.palette.secondary[200]} !important`,
            fontSize:"16px"
          },
        }}
      >
        <DataGrid
          loading={isLoading || !data}
          getRowId={(row) => row.id}
          rows={(data && data.data) || []}
          columns={columns}
          rowCount={(data && data.data.length) || 0}
          rowsPerPageOptions={[20, 50, 100]}
          page={page}
          onPageChange={(newPage) => setPage(newPage)}
        />
      </Box>
    </Box>
  );
};

export default TripList;
