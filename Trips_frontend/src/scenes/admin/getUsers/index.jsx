import {
  Box,
  Button,
  Modal,
  Typography,
  useTheme,
  TextField,
} from "@mui/material";
import React, { useState } from "react";
import { DataGrid } from "@mui/x-data-grid";
import { useGetUsersQuery, useChangeStatusUserMutation } from "state/api";
import Header from "components/Header";
import DataGridCustomToolbar from "components/DataGridCustomToolbar";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";

const GetUsers = () => {
  const [t, i18n] = useTranslation();
  const theme = useTheme();
  const navigate = useNavigate();
  //   const { data, isLoading } = useGetTripsQuery();
  const [page, setPage] = useState(0);
  const { data, isLoading } = useGetUsersQuery({
    page: page + 1,
  });
  console.log("data", data);
  const [openReservation, setOpenReservation] = React.useState(false);
  const [idToDelete, setIdToDelete] = useState(null);
  const [messageAnswer, setMessageAnswer] = useState("");
  const [
    changeStatus,
    { data: dataChangeStatus, isLoading: changeStatusIsLoading },
  ] = useChangeStatusUserMutation();

  const changeStatusClaimClicked = async (data) => {
    await changeStatus(data);
  };
  const columns = [
    {
      field: "id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "phone",
      headerName: "رقم الهاتف",
      flex: 2,
    },
    {
      field: "name",
      headerName: "الاسم",
      flex: 1,
    },
    {
      field: "status",
      headerName: "حالة المستخدم",
      flex: 1,
      renderCell: (params) => {
        return (
          <Box
            color={Boolean(params.row.status) ? "#4CAF50" : "#f42"}
            fontWeight="bold"
            fontSize="13px"
          >
            {Boolean(params.row.status) ? "مفعل" : "تم الحظر"}
          </Box>
        );
      },
    },
    {
      field: "actions",
      headerName: "Actions",
      width: 180,
      flex: 3,
      renderCell: (params) => (
        <div>
          {console.log("prrr", params.row)}
          <Button
            variant="outlined"
            onClick={() => {
              const data = {
                id: params.id,
                status: !params.row.status,
              };
              changeStatusClaimClicked(data);
            }}
            color={Boolean(params.row.status) === true ? "error" : "success"}
          >
            {Boolean(params.row.status) === true ? "حظر" : "فك الحظر"}
          </Button>
        </div>
      ),
    },
  ];
  const [pageSize, setPageSize] = useState(15);

  return (
    <Box m="1.5rem 2.5rem">
      <Header title="المستخدمين" />

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
          rows={(data && data?.data?.users?.data) || []}
          columns={columns}
          rowCount={(data && data?.data?.users?.total) || 0}
          rowsPerPageOptions={[data?.data?.users?.data?.length]}
          pagination
          page={page}
          pageSize={pageSize}
          onPageChange={(newPage) => setPage(newPage)}
          paginationMode="server"
          onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
        />
      </Box>
    </Box>
  );
};

export default GetUsers;
