% This script plots the one-sided spectrum using Fourier transform
% technique
clear
clc
close all

% Load error data for frequency analysis
load('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/data_TLE_LAGEOS1.mat')
load('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/data_thalassa_LAGEOS1.mat')
load ('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/errs_LAGEOS1.mat')

% length of input signal
len = length(t_UTC);              

% period of LAGEOS1 in mins
T_lageos1 = 225; 

% Find the mean motion in rads/day
meanmotion = 2 * pi/(T_lageos1/1440); 

% Choose sampling interval in mins based on critical nyquist frequency 
dt_min = 36;

% Find sampling frequency in rads/day
w_sampling = 2 * pi/(dt_min/1440); % rads/day

% Find frequency distribution in rads/day
w = w_sampling * (0:(len/2))/len;

% Express frequency as multiple of mean-motion
w = w/meanmotion;

%% Find fourier transform and frequency
%% semi-major axis
A = fft(a_err - mean(a_err));
P2A = abs(A/len);
P1A = P2A(1:len/2 + 1);
P1A(2:end-1) = 2 * P1A(2:end-1);

A_TLE = fft(a_TLE - mean(a_TLE));
P2A_TLE = abs(A_TLE/len);
P1A_TLE = P2A_TLE(1:len/2 + 1);
P1A_TLE(2:end-1) = 2 * P1A_TLE(2:end-1);

A_th = fft(a_th - mean(a_th));
P2A_th = abs(A_th/len);
P1A_th = P2A_th(1:len/2 + 1);
P1A_th(2:end-1) = 2 * P1A_th(2:end-1);

% figure(1)
% set(gca,'FontSize',14)
% grid on
% grid minor
% hold on
% plot(w,P1A,'b','LineWidth',1)
% xlabel('Frequency (n)','fontsize',16)
% ylabel('FT of semi-major axis','fontsize',16)

figure(2)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1A_TLE(2:end),'b','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of semi-major axis (km)','fontsize',16)

figure(3)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1A_th(2:end),'r','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of semi-major axis (km)','fontsize',16)

%% Inclination
INC = fft((inc_err - mean(inc_err))*180/pi);
P2INC = abs(INC/len);
P1INC = P2INC(1:len/2 + 1);
P1INC(2:end-1) = 2 * P1INC(2:end-1);

INC_TLE = fft((inc_TLE - mean(inc_TLE))*180/pi);
P2INC_TLE = abs(INC_TLE/len);
P1INC_TLE = P2INC_TLE(1:len/2 + 1);
P1INC_TLE(2:end-1) = 2 * P1INC_TLE(2:end-1);

INC_th = fft((inc_th - mean(inc_th))*180/pi);
P2INC_th = abs(INC_th/len);
P1INC_th = P2INC_th(1:len/2 + 1);
P1INC_th(2:end-1) = 2 * P1INC_th(2:end-1);

% figure(4)
% set(gca,'FontSize',14)
% grid on
% grid minor
% hold on
% plot(w,P1INC,'b','LineWidth',1)
% xlabel('Frequency (n)','fontsize',16)
% ylabel('FT of semi-major axis','fontsize',16)

figure(5)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1INC_TLE(2:end),'b','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of inclination (deg)','fontsize',16)


figure(6)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1INC_th(2:end),'r','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of inclination (deg)','fontsize',16)

%% Eccentricity
ECC = fft(ecc_err - mean(ecc_err));
P2ECC = abs(ECC/len);
P1ECC = P2ECC(1:len/2 + 1);
P1ECC(2:end-1) = 2 * P1ECC(2:end-1);

ECC_TLE = fft(ecc_TLE - mean(ecc_TLE));
P2ECC_TLE = abs(ECC_TLE/len);
P1ECC_TLE = P2ECC_TLE(1:len/2 + 1);
P1ECC_TLE(2:end-1) = 2 * P1ECC_TLE(2:end-1);

ECC_th = fft(ecc_th - mean(ecc_th));
P2ECC_th = abs(ECC_th/len);
P1ECC_th = P2ECC_th(1:len/2 + 1);
P1ECC_th(2:end-1) = 2 * P1ECC_th(2:end-1);

% figure(7)
% set(gca,'FontSize',14)
% grid on
% grid minor
% hold on
% plot(w,P1ECC,'b','LineWidth',1)
% xlabel('Frequency (n)','fontsize',16)
% ylabel('FT of Eccentricity','fontsize',16)

figure(8)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1ECC_TLE(2:end),'b','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of eccentricity (-)','fontsize',16)

figure(9)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1ECC_th(2:end),'r','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of eccentricity (-)','fontsize',16)
%% RAAN
RAAN = fft((raan_err - mean(raan_err))*180/pi);
P2RAAN = abs(RAAN/len);
P1RAAN = P2RAAN(1:len/2 + 1);
P1RAAN(2:end-1) = 2 * P1RAAN(2:end-1);

RAAN_TLE = fft((raan_TLE - mean(raan_TLE))*180/pi);
P2RAAN_TLE = abs(RAAN_TLE/len);
P1RAAN_TLE = P2RAAN_TLE(1:len/2 + 1);
P1RAAN_TLE(2:end-1) = 2 * P1RAAN_TLE(2:end-1);

RAAN_th = fft((raan_th - mean(raan_th))*180/pi);
P2RAAN_th = abs(RAAN_th/len);
P1RAAN_th = P2RAAN_th(1:len/2 + 1);
P1RAAN_th(2:end-1) = 2 * P1RAAN_th(2:end-1);

% figure(10)
% set(gca,'FontSize',14)
% grid on
% grid minor
% hold on
% plot(w,P1RAAN,'b','LineWidth',1)
% xlabel('Frequency (n)','fontsize',16)
% ylabel('FT of semi-major axis','fontsize',16)

figure(11)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1RAAN_TLE(2:end),'b','LineWidth',1)
%ylim([0 30000])
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of RAAN (deg)','fontsize',16)

figure(12)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1RAAN_th(2:end),'r','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of RAAN (deg)','fontsize',16)
%% Argument of perigee
ARGP = fft((argp_err - mean(argp_err))*180/pi);
P2ARGP = abs(ARGP/len);
P1ARGP = P2ARGP(1:len/2 + 1);
P1ARGP(2:end-1) = 2 * P1ARGP(2:end-1);

ARGP_TLE = fft((argp_TLE - mean(argp_TLE))*180/pi);
P2ARGP_TLE = abs(ARGP_TLE/len);
P1ARGP_TLE = P2ARGP_TLE(1:len/2 + 1);
P1ARGP_TLE(2:end-1) = 2 * P1ARGP_TLE(2:end-1);

ARGP_th = fft((argp_th - mean(argp_th))*180/pi);
P2ARGP_th = abs(ARGP_th/len);
P1ARGP_th = P2ARGP_th(1:len/2 + 1);
P1ARGP_th(2:end-1) = 2 * P1ARGP_th(2:end-1);

% figure(13)
% set(gca,'FontSize',14)
% grid on
% grid minor
% hold on
% plot(w,P1ARGP,'b','LineWidth',1)
% xlabel('Frequency (n)','fontsize',16)
% ylabel('FT of semi-major axis','fontsize',16)

figure(14)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1ARGP_TLE(2:end),'b','LineWidth',1)
%ylim([0.00001 1])
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of argument of perigee (deg)','fontsize',16)

figure(15)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1ARGP_th(2:end),'r','LineWidth',1)
%ylim([0.00001 1])
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of argument of perigee (deg)','fontsize',16)
%% True anomaly
NU = fft((nu_err - mean(nu_err))*180/pi);
P2NU = abs(NU/len);
P1NU = P2NU(1:len/2 + 1);
P1NU(2:end-1) = 2 * P1NU(2:end-1);

NU_TLE = fft((nu_TLE - mean(nu_TLE))*180/pi);
P2NU_TLE = abs(NU_TLE/len);
P1NU_TLE = P2NU_TLE(1:len/2 + 1);
P1NU_TLE(2:end-1) = 2 * P1NU_TLE(2:end-1);

NU_th = fft((nu_th - mean(nu_th))*180/pi);
P2NU_th = abs(NU_th/len);
P1NU_th = P2NU_th(1:len/2 + 1);
P1NU_th(2:end-1) = 2 * P1NU_th(2:end-1);

% figure(16)
% set(gca,'FontSize',14)
% grid on
% grid minor
% hold on
% plot(w,P1NU,'b','LineWidth',1)
% xlabel('Frequency (n)','fontsize',16)
% ylabel('FT of semi-major axis','fontsize',16)


figure(17)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1NU_TLE(2:end),'b','LineWidth',1)
%ylim([0.00001 2])
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of true anomaly (deg)','fontsize',16)

figure(18)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1NU_th(2:end),'r','LineWidth',1)
%ylim([0.00001 2])
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of true anomaly (deg)','fontsize',16)

%% Mean anomaly
M = fft((M_err - mean(M_err))*180/pi);
P2M = abs(M/len);
P1M = P2M(1:len/2 + 1);
P1M(2:end-1) = 2 * P1M(2:end-1);

M_TLE = fft((M_TLE - mean(M_TLE))*180/pi);
P2M_TLE = abs(M_TLE/len);
P1M_TLE = P2M_TLE(1:len/2 + 1);
P1M_TLE(2:end-1) = 2 * P1M_TLE(2:end-1);

M_th = fft((M_th - mean(M_th))*180/pi);
P2M_th = abs(M_th/len);
P1M_th = P2M_th(1:len/2 + 1);
P1M_th(2:end-1) = 2 * P1M_th(2:end-1);

% figure(19)
% set(gca,'FontSize',14)
% grid on
% grid minor
% hold on
% plot(w,P1M,'b','LineWidth',1)
% xlabel('Frequency (n)','fontsize',16)
% ylabel('FT of semi-major axis','fontsize',16)

figure(20)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1M_TLE(2:end),'b','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of mean anomaly (deg)','fontsize',16)

figure(21)
set(gca,'FontSize',14)
set(gca, 'YScale', 'log')
grid on
grid minor
hold on
plot(w(2:end),P1M_th(2:end),'r','LineWidth',1)
xlabel('\omega (n)','fontsize',16)
ylabel('P1(\omega) of mean anomaly (deg)','fontsize',16)