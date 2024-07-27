import React from "react";
import {
  Box,
  Divider,
  Drawer,
  IconButton,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Typography,
  useTheme,
} from "@mui/material";
import {
  SettingsOutlined,
  ChevronLeft,
  ChevronRightOutlined,
  ChevronLeftOutlined,
  HomeOutlined,
  ShoppingCartOutlined,
  Groups2Outlined,
  ReceiptLongOutlined,
  PublicOutlined,
  PointOfSaleOutlined,
  TodayOutlined,
  CalendarMonthOutlined,
  AdminPanelSettingsOutlined,
  TrendingUpOutlined,
  PieChartOutlined,
} from "@mui/icons-material";
import { useTranslation } from "react-i18next";
import AirportShuttleOutlinedIcon from "@mui/icons-material/AirportShuttleOutlined";
import LibraryAddOutlinedIcon from "@mui/icons-material/LibraryAddOutlined";
import { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import FlexBetween from "./FlexBetween";
import { decodeToken } from "react-jwt";
import { useSelector } from "react-redux";

const Sidebar = ({
  user,
  drawerWidth,
  isSidebarOpen,
  setIsSidebarOpen,
  isNonMobile,
}) => {
  const [t, i18n] = useTranslation();
  const { pathname } = useLocation();
  const [active, setActive] = useState("");
  const navigate = useNavigate();
  const theme = useTheme();

  const token = useSelector((state) => state.global.token);

  let decodedToken = null;
  if (token) {
    decodedToken = decodeToken(token) ?? null;
  }

  const isAll = Boolean(decodedToken?.roles?.includes("all"));
  const isCanReports = Boolean(decodedToken?.roles?.includes("reports"));
  const isCanControlTrips = Boolean(
    decodedToken?.roles?.includes("trips_control")
  );
  const isCanAddDriverAndAssistant = Boolean(
    decodedToken?.roles?.includes("add_drivers")
  );
  const isCanQuery = Boolean(decodedToken?.roles?.includes("query"));
  const isCanPayment = Boolean(decodedToken?.roles?.includes("payment"));

  const navItems = [
    {
      text: "Dashboard",
      icon: <HomeOutlined />,
    },
    {
      text: "Trips",
      icon: <AirportShuttleOutlinedIcon />,
    },
    {
      text: "get_company_user",
      icon: <AirportShuttleOutlinedIcon />,
    },
    {
      text: "Add_Driver",
      icon: <LibraryAddOutlinedIcon />,
    },
    {
      text: "Add_Assistant",
      icon: <LibraryAddOutlinedIcon />,
    },
    {
      text: "Add_Trip",
      icon: <LibraryAddOutlinedIcon />,
    },
    {
      text: "search_trip",
      icon: <LibraryAddOutlinedIcon />,
    },
    {
      text: "search_reservation",
      icon: <LibraryAddOutlinedIcon />,
    },
    {
      text: "trip_list",
      icon: <LibraryAddOutlinedIcon />,
    },
  ];

  useEffect(() => {
    setActive(pathname.substring(1));
  }, [pathname]);

  return (
    <Box component="nav">
      {isSidebarOpen && (
        <Drawer
          open={isSidebarOpen}
          onClose={() => setIsSidebarOpen(false)}
          variant="persistent"
          anchor={i18n.language === "en" ? "left" : "right"}
          sx={{
            width: drawerWidth,
            "& .MuiDrawer-paper": {
              color: theme.palette.secondary[200],
              backgroundColor: theme.palette.background.alt,
              boxSixing: "border-box",
              borderWidth: isNonMobile ? 0 : "2px",
              width: drawerWidth,
            },
          }}
        >
          <Box width="100%">
            <Box m="1.5rem 2rem 2rem 3rem">
              <FlexBetween color={theme.palette.secondary.main}>
                <Box>
                  <Typography
                    variant="h2"
                    fontWeight="bold"
                    sx={{ textAlign: "center", mr: isNonMobile ? "3rem" : "" }}
                  >
                    رحلات
                  </Typography>
                </Box>
                {!isNonMobile && (
                  <IconButton onClick={() => setIsSidebarOpen(!isSidebarOpen)}>
                    <ChevronLeft />
                  </IconButton>
                )}
              </FlexBetween>
            </Box>
            <List>
              {navItems.map(({ text, icon }) => {
                if (!icon) {
                  return (
                    <Typography key={text} sx={{ m: "2.25rem 0 1rem 3rem" }}>
                      {text}
                    </Typography>
                  );
                }
                const lcText = text.toLowerCase();
                // if (lcText === "dashboard" && !isAll && !isCanReports) {
                //   return;
                // }
                if (
                  lcText === "trips" &&
                  !isAll &&
                  !isCanControlTrips &&
                  !isCanQuery
                ) {
                  return;
                }
                if (lcText === "get_company_user" && !isAll) {
                  return;
                }
                if (
                  lcText === "add_driver" &&
                  !isAll &&
                  !isCanAddDriverAndAssistant
                ) {
                  return;
                }
                if (
                  lcText === "add_assistant" &&
                  !isAll &&
                  !isCanAddDriverAndAssistant
                ) {
                  return;
                }
                if (lcText === "add_trip" && !isAll && !isCanControlTrips) {
                  return;
                }
                if (
                  lcText === "search_trip" &&
                  !isAll &&
                  !isCanControlTrips &&
                  !isCanQuery &&
                  !isCanPayment
                ) {
                  return;
                }
                if (
                  lcText === "search_reservation" &&
                  !isAll &&
                  !isCanControlTrips &&
                  !isCanQuery &&
                  !isCanPayment
                ) {
                  return;
                }
                if (lcText === "trip_list" && !isAll && !isCanControlTrips) {
                  return;
                }
                return (
                  <ListItem key={text} disablePadding>
                    <ListItemButton
                      onClick={() => {
                        navigate(`/${lcText}`);
                        setActive(lcText);
                      }}
                      sx={{
                        backgroundColor:
                          active === lcText
                            ? theme.palette.secondary[300]
                            : "transparent",
                        color:
                          active === lcText
                            ? theme.palette.primary[600]
                            : theme.palette.secondary[50],
                      }}
                    >
                      <ListItemIcon
                        sx={{
                          ml: i18n.language === "en" ? "2rem" : "0",
                          color:
                            active === lcText
                              ? theme.palette.primary[600]
                              : theme.palette.secondary[50],
                        }}
                      >
                        {icon}
                      </ListItemIcon>
                      <ListItemText
                        primary={t(text.toLowerCase())}
                        sx={{
                          ml: i18n.language === "ar" ? "1rem" : 0,
                          textAlign: "start",
                        }}
                        primaryTypographyProps={{
                          fontSize: "18px",
                          fontWeight: "bold",
                        }}
                      />
                      {active === lcText &&
                        (i18n.language === "en" ? (
                          <ChevronRightOutlined sx={{ ml: "auto" }} />
                        ) : (
                          <ChevronLeftOutlined />
                        ))}
                    </ListItemButton>
                  </ListItem>
                );
              })}
            </List>
          </Box>

          <Box position="absolute" bottom="2rem">
            <Divider />
            {/* <FlexBetween textTransform="none" gap="1rem" m="1.5rem 2rem 0 3rem">
              <Box
                component="img"
                alt="profile"
                src={profileImage}
                height="40px"
                width="40px"
                borderRadius="50%"
                sx={{ objectFit: "cover" }}
              />
              <Box textAlign="left">
                <Typography
                  fontWeight="bold"
                  fontSize="0.9rem"
                  sx={{ color: theme.palette.secondary[50] }}
                >
                  {user.name}
                </Typography>
                <Typography
                  fontSize="0.8rem"
                  sx={{ color: theme.palette.secondary[200] }}
                >
                  {user.occupation}
                </Typography>
              </Box>
              <SettingsOutlined
                sx={{
                  color: theme.palette.secondary[300],
                  fontSize: "25px ",
                }}
              />
            </FlexBetween> */}
          </Box>
        </Drawer>
      )}
    </Box>
  );
};

export default Sidebar;
