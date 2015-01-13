function [data,label]= Data_Inspection(data,label)
    [data_rows,data_cols] = size(data);
    [label_rows,label_cols] = size(label);
    mat = zeros(data_rows,21);
    label_mat = zeros(label_rows,1);
for k=1:data_rows
    if strcmp(label(k,1),'unacc')==1
        label_mat(k,1)=1; 
    elseif strcmp(label(k,1),'acc')==1
        label_mat(k,1)=2; 
    elseif strcmp(label(k,1),'good')==1
        label_mat(k,1)=3;
    elseif strcmp(label(k,1),'vgood')==1
        label_mat(k,1)=4; 
    end
    if strcmp(data{k,1},'vhigh')
       mat(k,1)=1;
    elseif strcmp(data{k,1},'high')
       mat(k,2)=1;
    elseif strcmp(data{k,1},'med')
       mat(k,3)=1;
    elseif strcmp(data{k,1},'low')
       mat(k,4)=1;
    end
    if strcmp(data{k,2},'vhigh')
       mat(k,5)=1;
    elseif strcmp(data{k,2},'high')
       mat(k,6)=1;
    elseif strcmp(data{k,2},'med')
       mat(k,7)=1;
    elseif strcmp(data{k,2},'low')
       mat(k,8)=1;
    end
    if data{k,3}==2
       mat(k,9)=1;
    elseif data{k,3} == 3
       mat(k,10)=1;
    elseif data{k,3} == 4
       mat(k,11)=1;
    elseif data{k,3} >= 5
       mat(k,12)=1;
    end
    if data{k,4} == 2
       mat(k,13)=1;
    elseif data{k,4} == 4
       mat(k,14)=1;
    elseif data{k,4} > 4
       mat(k,15)=1;
    end
    if strcmp(data{k,5},'small')
       mat(k,16)=1;
    elseif strcmp(data{k,5},'med')
       mat(k,17)=1;
    elseif strcmp(data{k,5},'big')
       mat(k,18)=1;
    end
    if strcmp(data{k,6},'low')
       mat(k,19)=1;
    elseif strcmp(data{k,6},'med')
       mat(k,20)=1;
    elseif strcmp(data{k,6},'high')
       mat(k,21)=1;
    end
end
    data = mat;
    label = label_mat;
    
    

end