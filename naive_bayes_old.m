function [new_accu, train_accu] = naive_bayes_old(train_data, train_label, new_data, new_label)
% naive bayes classifier
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  new_data: M*D matrix, each row as a sample and each column as a
%  feature
%  new_label: M*1 vector, each row as a label
%
% Output:
%  new_accu: accuracy of classifying new_data
%  train_accu: accuracy of classifying train_data 
%
% CSCI 576 2014 Fall, Homework 1
[N,D] = size(train_data);

countOfAcceptance=0;
countOfUnacceptance=0;
countOfGood=0;
countOfVgood=0;
for i=1:N
    if(strcmp(train_label(i,1),'acc'))
        countOfAcceptance=countOfAcceptance+1;
    else
        if (strcmp(train_label(i,1),'unacc'))
        countOfUnacceptance=countOfUnacceptance+1;
        else
            if (strcmp(train_label(i,1),'good'))
                countOfGood = countOfGood+1;
            else
                if (strcmp(train_label(i,1),'vgood'))
                    countOfVgood=countOfVgood+1;
                end
            end
        end
    end
end


probOfAcceptance   = countOfAcceptance / N;
probOfUnacceptance = countOfUnacceptance / N;
probOfGood = countOfGood/N;
probOfVgood = countOfVgood/N;

validValues= { 'vhigh', 'high', 'med', 'low';
               'vhigh', 'high', 'med', 'low';
               2,3,4,5;
               2,4,5,-1;
               'small', 'med', 'big','None';
               'low', 'med', 'high','None'
               };
           
function col=findString (f,searchVal)
    col=-1;
    for j=1:4
        if (strcmp(validValues(f,j),searchVal))
            col=j;
            break;
        end
    end
end

function col=findNumber(f,searchVal)
    col=-1;
    for j=1:4
        if (isequal(validValues(f,j),searchVal))
            col=j;
            break;
        end
    end
end


%calculate the conditional probabilities of each feature
%rowsXfeaturesXvalues
% since the max number of property per feature is 4 the last 
%dim is set to 4

conditionalProbMatrix=zeros(6,4,4);
for n=1:N
    x=0;
    switch train_label{n,1}
            case 'acc'
                x=1;
            case 'unacc'
                x=2;
            case 'good'
                x=3;
            case 'vgood'
                x=4;
    end
    for f=1:D
        property=train_data(n,f);
        if (f==3 || f==4)
            value = findNumber(f,property);
        else
            value = findString(f,property);
        end
        if (value~=-1 && x~=0)
            conditionalProbMatrix(f,value,x)=conditionalProbMatrix(f,value,x)+1;
        end
    end
end


for c=1:4
    switch c
        case 1
            conditionalProbMatrix(:,:,c)=conditionalProbMatrix(:,:,c)/countOfAcceptance;
        case 2
            conditionalProbMatrix(:,:,c)=conditionalProbMatrix(:,:,c)/countOfUnacceptance;
        case 3
            conditionalProbMatrix(:,:,c)=conditionalProbMatrix(:,:,c)/countOfGood;
        case 4
            conditionalProbMatrix(:,:,c)=conditionalProbMatrix(:,:,c)/countOfVgood;
    end
end

%conditionalProbMatrix

function accuracy=findOutput(test_data,test_label)
    [testN,testD] =  size(test_data);

accuracy=0;
    for testRow = 1:testN
        prevPerClassProbability=0;
        maxProbableClass=0;
        for class = 1:4
            perClassProbability=1;
            for feature = 1:6
                fieldValue=test_data(testRow,feature);
                if (feature==3 || feature==4)
                    newValue = findNumber(feature,fieldValue);
                else
                    newValue = findString(feature,fieldValue);
                end
                if (newValue~=-1 )
                    perClassProbability = perClassProbability *conditionalProbMatrix(feature,newValue,class);
                end
            end
            switch class
                case 1
                    perClassProbability=perClassProbability*probOfAcceptance;
                case 2
                    perClassProbability=perClassProbability*probOfUnacceptance;
                case 3
                    perClassProbability=perClassProbability*probOfGood;
                case 4
                        perClassProbability=perClassProbability*probOfVgood;
            end
            if prevPerClassProbability < perClassProbability
                prevPerClassProbability = perClassProbability;
                maxProbableClass = class;
            end
        end
        finalClass=0;
        switch test_label{testRow,1}
                case 'acc'
                    finalClass=1;
                case 'unacc'
                    finalClass=2;
                case 'good'
                    finalClass=3;
                case 'vgood'
                    finalClass=4;
        end
    
        if (maxProbableClass==finalClass)
            accuracy=accuracy+1;
        end
    end
    accuracy=(accuracy/testN)*100;
end


new_accu=findOutput(new_data, new_label);
train_accu=findOutput(train_data, train_label);
end