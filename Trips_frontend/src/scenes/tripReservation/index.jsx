import {
  Box,
  Button,
  useTheme,
  Dialog,
  DialogContent,
  Typography,
  TextField,
  Modal,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import Header from "components/Header";
import React, { useState } from "react";
import { useParams } from "react-router-dom";
import {
  useGetTripReservationsQuery,
  useConfirmReservationMutation,
} from "state/api";

const TripReservations = () => {
  const { tripId } = useParams();
  const [selectedReservation, setSelectedReservation] = useState(null);
  const [openDialog, setOpenDialog] = useState(false);
  const [openModal, setOpenModal] = useState(false);
  const [idForReservation, setIdForReservation] = useState(null);
  const [seatsData, setSeatsData] = useState(null);
  const theme = useTheme();
  const { data, isLoading } = useGetTripReservationsQuery(tripId);
  const [confirmReservation, { isSuccess, isLoading: isConfirmLoading }] =
    useConfirmReservationMutation();

  const onConfirmClicked = async (id) => {
    await confirmReservation(id);
    handleCloseModal();
  };
  const columns = [
    {
      field: "unique_id",
      headerName: "رقم الحجز",
      flex: 1,
    },
    {
      field: "user.name",
      headerName: "الاسم",
      flex: 1,
      valueGetter: (params) => params.row.seats[0].name,
    },
    {
      field: "user.phone",
      headerName: "رقم الهاتف",
      flex: 1,
      valueGetter: (params) =>
        params.row.user !== null ? params.row.user.phone : params.row.phone,
    },
    {
      field: "seats.length",
      headerName: "عدد المقاعد",
      flex: 1,
      valueGetter: (params) => params.row.seats.length,
    },
    {
      field: "seatNumbers",
      headerName: "ارقام المقاعد",
      flex: 1,
      renderCell: (params) => {
        const reservation = params.row;
        const seatNumbers = reservation.seats
          .map((seat) => seat.number_seat)
          .join(", ");

        const handleSeatClick = (reservationData) => {
          setSelectedReservation(reservationData);
          setOpenDialog(true);
        };

        return (
          <div>
            <button onClick={() => handleSeatClick(reservation)}>
              {seatNumbers}
            </button>
          </div>
        );
      },
    },

    {
      field: "reservationType",
      headerName: "نوع الحجز",
      flex: 1,
      // valueGetter: (params) => params.row.seats[0].status === "temporary" ? 'مؤقت' :'مؤكد'
      renderCell: (params) => (
        <div>
          <Box
            display="flex"
            gap="1.5rem"
            sx={{
              "& .MuiButton-outlined": {
                borderColor: theme.palette.secondary[300] + "!important",
                color: theme.palette.secondary[300],
              },
            }}
          >
            <Typography variant="h3">
              {params.row.seats[0].status === "temporary" ? "مؤقت" : "مؤكد"}
            </Typography>
            {/* {params.row.seats[0].status === "temporary" && (
              <Button
                sx={{ marginLeft: "12px" }}
                disabled={isConfirmLoading ? true : false}
                onClick={() => {
                  setIdForReservation(params.row.id);
                  const reservation = params.row;
                  const seatNumbers = reservation.seats
                    .map((seat) => seat.number_seat)
                    .join(", ");
                  setSeatsData(seatNumbers);
                  setSelectedReservation(reservation);
                  setOpenModal(true);
                }}
                setSe
                variant="outlined"
              >
                تثبيت
              </Button>
            )} */}
          </Box>
        </div>
      ),
    },
  ];
 
  const handleCloseModal = () => {
    setOpenModal(false);
  };
  const styleModal = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 600,
    bgcolor: "background.paper",
    border: "2px solid #000",
    // boxShadow: 24,
    p: 4,
  };

  return (
    <>
      <Modal
        open={openModal}
        onClose={handleCloseModal}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
        sx={{
          textAlign: "right",
        }}
      >
        <Box sx={styleModal}>
          <>
            <Typography
              id="modal-modal-title"
              variant="h2"
              component="h2"
              textAlign="right"
              sx={{ textDecoration: "none", mb: "2rem" }}
            >
              تثبيت الحجز المُنجز الكترونياََ
            </Typography>
            <Typography variant="h6">
              {console.log("reservation", selectedReservation)}
              {/* {selectedReservation?.user
                ? `User: + ${selectedReservation?.user?.name}`
                : "From Company"} */}
            </Typography>

            <div>
              <Typography sx={{ fontSize: "22px" }} variant="h6">
                عدد المقاعد : &nbsp;{selectedReservation?.seats?.length}
              </Typography>
              <Typography sx={{ fontSize: "22px" }} variant="body1">
                سعر التذكرة: {selectedReservation?.ticket_price}
              </Typography>
              <Typography sx={{ fontSize: "22px" }} variant="body1" dir="rtl">
                الاسم: {selectedReservation?.user?.name}
              </Typography>
              <Typography sx={{ fontSize: "22px" }} variant="body1">
                أرقام المقاعد: {seatsData}
              </Typography>
              <Typography sx={{ fontSize: "26px" }} variant="body1">
                السعر الاجمالي:{" "}
                {selectedReservation?.ticket_price *
                  selectedReservation?.seats?.length}
              </Typography>
              <hr />
              <Button
                color="success"
                onClick={() => onConfirmClicked(selectedReservation?.id)}
                sx={{ fontSize: "22px" }}
              >
                تأكيد
              </Button>
              <Button
                sx={{ fontSize: "22px" }}
                color="error"
                onClick={handleCloseModal}
              >
                إلغاء
              </Button>
            </div>
          </>
        </Box>
      </Modal>
      <Box m="1.5rem 2.5rem">
        <Header title="الرحلات" subtitle="الحجوزات الحالية" />

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
              fontSize: "16px",
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
              fontSize: "16px",
            },
          }}
        >
          <DataGrid
            loading={isLoading || !data}
            getRowId={(row) => row.id}
            rows={(data && data.data.reservations) || []}
            columns={columns}
            rowCount={(data && data.data.length) || 0}
            rowsPerPageOptions={[20, 50, 100]}
          />
          {/* <Dialog open={openDialog} onClose={handleCloseDialog}>
            <DialogContent>
              {selectedReservation && (
                <>
                  <Typography variant="h6">
                    {selectedReservation?.user
                      ? `User: + ${selectedReservation?.user?.name}`
                      : "From Company"}
                  </Typography>
                  {selectedReservation.seats.map((seat, index) => (
                    <div key={index}>
                      <Typography variant="h6">Seat {index + 1}</Typography>
                      <Typography variant="body1">Name: {seat.name}</Typography>
                      <Typography variant="body1">
                        Seat Number: {seat.number_seat}
                      </Typography>
                      <hr />
                    </div>
                  ))}
                  <Button
                    onClick={handleCloseDialog}
                    variant="contained"
                    color="primary"
                  >
                    Close
                  </Button>
                </>
              )}
            </DialogContent>
          </Dialog> */}
        </Box>
      </Box>
    </>
  );
};

export default TripReservations;
