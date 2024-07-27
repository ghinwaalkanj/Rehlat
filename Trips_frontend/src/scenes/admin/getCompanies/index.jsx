import { Avatar, Box, Button, Typography, useTheme } from "@mui/material";
import React, { useState } from "react";
import { DataGrid } from "@mui/x-data-grid";
import {
  useGetClaimsQuery,
  useGetCompaniesQuery,
  useGetTripListQuery,
} from "state/api";
import Header from "components/Header";
import DataGridCustomToolbar from "components/DataGridCustomToolbar";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";

const GetCompanies = () => {
  const [t, i18n] = useTranslation();
  const theme = useTheme();
  const navigate = useNavigate();
  //   const { data, isLoading } = useGetTripsQuery();
  const [page, setPage] = useState(0);
  const { data, isLoading } = useGetCompaniesQuery();
  console.log("data", data);

  // values to be sent to the backend
  // const [page, setPage] = useState(0);
  // const [pageSize, setPageSize] = useState(20);
  // const [searchInput, setSearchInput] = useState("");
  const columns = [
    {
      field: "id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "name",
      headerName: "الاسم ",
      flex: 1,
    },
    {
      field: "username",
      headerName: " اسم المستخدم",
      flex: 1,
    },
    {
      field: "logo",
      headerName: "الشعار",
      flex: 1,
      renderCell: (params) => {
        return <Avatar alt="logo" src={params.row.logo} />;
      },
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
              onClick={() => navigate(`/admin/edit_company/${params.id}`)}
              variant="outlined"
            >
              تعديل
            </Button>
          </Box>
        </div>
      ),
    },
  ];

  return (
    <Box m="1.5rem 2.5rem">
      <Box mb="2rem" display="flex" justifyContent="space-between">
        <Header title="الوكالات" />
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
            sx={{ marginLeft: "12px", fontSize: "16px" }}
            onClick={() => navigate(`/admin/add_company`)}
            variant="outlined"
          >
            اضافة وكالة سفر
          </Button>
        </Box>
      </Box>
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
          rows={(data && data?.data?.companies) || []}
          columns={columns}
          rowCount={(data && data?.data?.companies.length) || 0}
          rowsPerPageOptions={[data?.data?.companies?.length]}
          page={page}
          onPageChange={(newPage) => setPage(newPage)}
        />
      </Box>
    </Box>
  );
};

export default GetCompanies;
