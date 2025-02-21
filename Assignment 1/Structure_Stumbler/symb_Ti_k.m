Ti_k = [
[                                          0, 0, -L_stance*cos(gamma1),                                          0,                              0,                       0]
[                                          0, 0, -L_stance*sin(gamma1),                                          0,                              0,                       0]
[                                          0, 0,                     0,                                          0,                              0,                       0]
[-(433*L_thigh*sin(alpha2)*sin(gamma2))/1000, 0, -L_stance*cos(gamma1), (433*L_thigh*cos(alpha2)*cos(gamma2))/1000,                              0,                       0]
[ (433*L_thigh*cos(gamma2)*sin(alpha2))/1000, 0, -L_stance*sin(gamma1), (433*L_thigh*cos(alpha2)*sin(gamma2))/1000,                              0,                       0]
[            -(433*L_thigh*cos(alpha2))/1000, 0,                     0,                                          0,                              0,                       0]
[           -L_thigh*sin(alpha2)*sin(gamma2), 0, -L_stance*cos(gamma1),            L_thigh*cos(alpha2)*cos(gamma2), (433*L_shank*cos(gamma3))/1000,                       0]
[            L_thigh*cos(gamma2)*sin(alpha2), 0, -L_stance*sin(gamma1),            L_thigh*cos(alpha2)*sin(gamma2), (433*L_shank*sin(gamma3))/1000,                       0]
[                       -L_thigh*cos(alpha2), 0,                     0,                                          0,                              0,                       0]
[           -L_thigh*sin(alpha2)*sin(gamma2), 0, -L_stance*cos(gamma1),            L_thigh*cos(alpha2)*cos(gamma2),            L_shank*cos(gamma3), -(L_foot*sin(gamma4))/2]
[            L_thigh*cos(gamma2)*sin(alpha2), 0, -L_stance*sin(gamma1),            L_thigh*cos(alpha2)*sin(gamma2),            L_shank*sin(gamma3),  (L_foot*cos(gamma4))/2]
[                       -L_thigh*cos(alpha2), 0,                     0,                                          0,                              0,                       0]
 
];
