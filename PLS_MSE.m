%%%%%PLS%%%%
mse_pre_task_rem=mse_pre_task_rem';
mse_pre_task_sws=mse_pre_task_sws';
mse_post_task_sws=mse_post_task_sws';
mse_post_task_rem=mse_post_task_rem';

giant_mse={mse_pre_task_rem;mse_pre_task_sws;mse_post_task_sws;mse_post_task_rem}; %%%make a cell array out of 4conditions (pre/post task-REM/SWS)
num_cond=1; %%set the number of condition
num_subj=[274,752,282,950]; %% set the number of each subj, that you wanna explore their data
%%%%set the option struct base on PLS user manual and dicription%%%
option.method=1;
option.meancentering_type=1;
option.num_boot=500;
option.num_perm=1000;
addpath C:\Users\Rezvaneh\Downloads\plscmd; %%%add your own path-not adding the whole folder of pls may cause in unsolvable errors!
results_rem=pls_analysis(giant_mse,num_subj,num_cond,option);

%%%%Plotting LVs%%%%%%
LV = 1; %%%set the number of 'latent variables' base on the number of subj-condition you're investigating-here I test LV={1,2,3,4}
x = results_rem.boot_result.orig_usc(:,LV);
x = reshape(x,1,4);%task scores
figure
bar(x')
xticklabels({'rem pre','sws pre','rem post','sws post'})
yticks(1:26)
xlabel('Conditions over runs')
colorbar
ylabel('sample entropy')
title(sprintf('MSE over Source'))

%%%% visualize bootstraps with thresholds

bsr = results_rem.boot_result.compare_u(:,LV);
bsr_thresh = 2;
figure;
bar(bsr); 
hold on;
plot([1:100],bsr_thresh*ones(1,100),'r:');
plot([1:100],-bsr_thresh*ones(1,100),'r:')
