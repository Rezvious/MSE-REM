%clc;clear all; close all;
%%%%%% Add Fieldtrip Pacakage%%%%
%%uncomment 2 below comments if you don't have FT package, in other case leave it commented
%addpath E:\Research\MSc\Data\FieldTrip\fieldtrip-lite-20210328\fieldtrip-20210328;
%ft_defaults;
%%%%%% Load dataset%%%%%%
% ncs data
ncs_path = 'C:\Users\Rezvaneh\Desktop\McIntosh Lab\Sleep Hypothesis\ncs_file'; %%change path to your desired path
cfg            = [];
cfg.dataset    = ncs_path;
ncs_data       = ft_preprocessing(cfg);
%%%%Load important event file (epochs.mat) %%%%
load 'C:\Users\Rezvaneh\Desktop\McIntosh Lab\Sleep Hypothesis\Data\epochs.mat';

%%%% Make a copy of data + a row specified to the size of the start and endpoint of the whole data

a = 1745994149:500:25450569649; %%%% Timestamp's vector associated with the data vector
b = ncs_data.trial{1,1}; %%% A copy of dataset
%%c = b(find(a==epochs.tsrem1(1,1)*100):find(a==epochs.tsrem1(1,2)*100)); %%%finding the indexes of data based on important events
E='tsrem1'; %%%change it based on the duration you wanna search important events in it (it can be: tsrem1/tsrem2/tssws1/tssws2) 
for i=1:length(epochs.E)
    G{i}=b(find(a==epochs.E(i,1)*100):find(a==epochs.E(i,2)*100)); %%%%finding the indexes of data based on important events and assigning to cells
end
for i=1:length(epochs.E)
    G{i}=transpose(G{i}); %%%% Transpose G{i} for further Mean and STD calculations ( Make a vector out of each data)
end;
for i=1:length(epochs.E)
    eval(sprintf('c%d = G{i}', i)); %%% extracting cells into variables
end;
%%%% Pre calculation prior to Mean_MSE and STD_MSE calculations%%%%
sampling_freq=2000;  %%%% changeable variable, so tune base on sampling freq
sample=2; %%%%% Changeable, tune base on the specific trial you wanna look into, here is = 2s
V=sample*sampling_freq;
data=[];
s=1;  %%% s is equal to the c%d index, so change it based on c's index (c1=> s=1)
D=eval(sprintf('c%d',s)) %%%% Making a dynamic variable for easily changing c in other equations
for j=1:round(length(D)/V) %%%change the c%i to tge specific c%i you're looking into {e.g. c1,c2,...c27}
    data(:,j)=D(V*j-(V-1):V*j) %%%% Segmenting each row of important events into 4000 rows and different columns (based on the length of each c%d the columns are different, but rows are fixed on 4000)
end;
%%%%%% Mean_MSE & STD_MSE calculation + Plotting them %%%%%
%%%%Don't forget to run the codes provided in this repo "https://github.com/McIntosh-Lab/mclab-mse" into a "live
%%%%script" matlab section prior to running the function I used
[mean_mse,std_mse,scales]= get_mse_curve_across_trials(data);
figure;
plot(scales,mean_mse);
xlabel('Scales');
ylabel('Mean MSE');
title(sprintf('Mean MSE per Scales-Pre Task REM%d',s));
figure;
plot(scales,std_mse);
xlabel('Scales');
ylabel('STD MSE');
title(sprintf('STD MSE per Scales-Pre Task REM%d',s));
D=[];
for i=1:length(epochs.tsrem1)
    D(i)=length(sprintf('c%d',i))
end;