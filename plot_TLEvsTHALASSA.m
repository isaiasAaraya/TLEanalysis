% Plotting script
clear
clc
close all

% Load LAGEOS-1 data
load('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/data_TLE_LAGEOS1.mat')
load('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/data_thalassa_LAGEOS1.mat')
load ('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/errs_LAGEOS1.mat')


% % Semi-major axis comparison
% figure(1)
% set(gca,'FontSize',14)
% plot(t_UTC,a_TLE)
% hold on
% plot(t_UTC,a_POE)
% xlabel('Date','fontsize',16)
% ylabel('Semi-major axis (km)','fontsize',16)
% title('Semi-major comparison','fontsize',16)
% legend('TLE','POE','fontsize',16)
% 
% % Eccentricity comparison
% figure(2)
% set(gca,'FontSize',14)
% plot(t_UTC,ecc_TLE)
% hold on
% plot(t_UTC,ecc_POE)
% xlabel('Date','fontsize',16)
% ylabel('Eccentricity','fontsize',16)
% title('Eccentricity comparison','fontsize',16)
% legend('TLE','POE','fontsize',16)
% 
% % Inclination comparison
% figure(3)
% set(gca,'FontSize',14)
% plot(t_UTC,inc_POE)
% hold on
% plot(t_UTC,inc_TLE)
% xlabel('Date','fontsize',16)
% ylabel('Inclination (rad)','fontsize',16)
% title('Inclination comparison','fontsize',16)
% legend('POE','TLE','fontsize',16)
% 
% % RAAN comparison
% figure(4)
% set(gca,'FontSize',14)
% plot(t_UTC,raan_POE)
% hold on
% plot(t_UTC,raan_TLE)
% xlabel('Date','fontsize',16)
% ylabel('RAAN (rad)','fontsize',16)
% title('Right ascension of the ascending node (RAAN) comparison','fontsize',16)
% legend('POE','TLE','fontsize',16)
% 
% 
% % Argument of perigee comparison
% figure(5)
% set(gca,'FontSize',14)
% plot(t_UTC,argp_POE)
% hold on
% plot(t_UTC,argp_TLE)
% xlabel('Date','fontsize',16)
% ylabel('Argument of perigee (rad)','fontsize',16)
% title('Argument of perigee comparison','fontsize',16)
% legend('POE','TLE','fontsize',16)
% 
% % True anomaly comparison
% figure(6)
% set(gca,'FontSize',14)
% plot(t_UTC,nu_TLE)
% hold on
% plot(t_UTC,nu_POE)
% xlabel('Date','fontsize',16)
% ylabel('True anomaly (rad)','fontsize',16)
% title('True anomaly comparison','fontsize',16)
% legend('TLE','POE','fontsize',16)

% Position error
figure(7)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,movmean(rerr_r,360),'linewidth',1.2)
plot(t_UTC,movmean(serr_r,360),'linewidth',1.2)
plot(t_UTC,movmean(werr_r,360),'linewidth',1.2)
plot(t_UTC,movmean(r_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (km)','fontsize',20)
title('Position error','fontsize',16)
legend('Radial','Along-track','Cross-track','Range','fontsize',20)

% Velocity error
figure(8)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,1000*movmean(rerr_v,360),'linewidth',1.2)
plot(t_UTC,1000*movmean(serr_v,360),'linewidth',1.2)
plot(t_UTC,1000*movmean(werr_v,360),'linewidth',1.2)
plot(t_UTC,1000*movmean(v_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (m/s)','fontsize',20)
title('Velocity error comparison','fontsize',16)
legend('Radial','Along-track','Cross-track','Magnitude','fontsize',20)

% Semi-major axis error
figure(9)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,movmean(a_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (km)','fontsize',20)
title('Semi-major','fontsize',16)

% Eccentricity error
figure(10)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,movmean(ecc_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (-)','fontsize',20)
title('Eccentricity','fontsize',16)

% Inclination error
figure(11)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,(180/pi)*movmean(inc_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (deg)','fontsize',20)
title('Inclination','fontsize',16)

% Argument of perigee error
figure(12)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,(180/pi)*movmean(argp_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (deg)','fontsize',20)
title('Argument of perigee','fontsize',16)

% RAAN error
figure(13)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,(180/pi)*movmean(raan_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (deg)','fontsize',20)
title('RAAN','fontsize',16)

% True anomaly error
figure(14)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,(180/pi)*movmean(nu_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (deg)','fontsize',20)
title('True anomaly','fontsize',16)

% Mean anomaly error
figure(15)
set(gca,'FontSize',20)
grid on
grid minor
hold on
plot(t_UTC,(180/pi)*movmean(M_err,360),'linewidth',1.2)
xlabel('Date','fontsize',20)
ylabel('Absolute error (deg)','fontsize',20)
title('Mean anomaly','fontsize',16)