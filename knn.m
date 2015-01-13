function [new_accu, train_accu] = knn_classify(train_data, train_label, new_data, new_label, k)
% k-nearest neighbor classifier
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  new_data: M*D matrix, each row as a sample and each column as a
%  feature
%  new_label: M*1 vector, each row as a label
%  k: number of nearest neighbors
%
% Output:
%  new_accu: accuracy of classifying new_data
%  train_accu: accuracy of classifying train_data (using leave-one-out
%  strategy)
%
% CSCI 576 2014 Fall, Homework 1

validValues= { 'vhigh', 'high', 'med', 'low';
               'vhigh', 'high', 'med', 'low';
               2,3,4,5;
               2,4,5,-1;
               'small', 'med', 'big','None';
               'low', 'med', 'high','None'
               };

%function to convert domain value to integers
function col=findString (f,searchVal)
    col=-1;
    for j=1:4
        if (strcmp(validValues(f,j),searchVal))
            col=j;
            break;
        end
    end
end

%function to convert domain value to integers
function col=findNumber(f,searchVal)
    col=-1;
    for j=1:4
        if (isequal(validValues(f,j),searchVal))
            col=j;
            break;
        end
    end
end

%function to find k nearest neighbours to a point
function class=findKNearestPoints(data,row,k)
    newPoint=zeros(1,6);
    class=0;
    %classDistance is an array that maintains class distance pair for k
    %times. the first row holds the column values and the second row holds
    %the distance value
    
    classDistance=zeros(2,k);
    classDistance(2,:)=100;
     for d=1:D
        outValue=data(row,d);
        if (d==3 || d==4)
            newPoint(d) = findNumber(d,outValue);
        else
            newPoint(d) = findString(d,outValue);
        end
     end
     %newPoint
     for d1=1:4
         for d2=1:4
             for d3=1:4
                 for d4=1:3
                     for d5=1:3
                         for d6=1:3
                             distance = abs(newPoint(1)-d1)+abs(newPoint(2)-d2)+abs(newPoint(3)-d3)+abs(newPoint(4)-d4)+abs(newPoint(5)-d5)+abs(newPoint(6)-d6);
                             for numK=1:k
                                 if (classDistance(2,numK)>distance && training_graph(d1,d2,d3,d4,d5,d6)~=0)
                                     classDistance(2,numK)=distance;
                                     classDistance(1,numK)=training_graph(d1,d2,d3,d4,d5,d6);
                                     break;
                                 end
                             end
                         end
                     end
                 end
             end
         end
     end 
     %classDistance
     countForClass=zeros(1,4);
     for iterK=1:k
         switch classDistance(1,iterK)
             case 1
                 countForClass(1,1)=countForClass(1,1)+1;
             case 2
                 countForClass(1,2)=countForClass(1,2)+1;
             case 3
                 countForClass(1,3)=countForClass(1,3)+1;
             case 4
                 countForClass(1,4)=countForClass(1,4)+1;
         end
     end
     class=find(countForClass==(max(max(countForClass))));
end

%function to find accuracy
function accuracy=findOutput(test_data,test_label,k)
    [testN,testD] =  size(test_data);
accuracy=0;
        
    for testRow = 1:testN
        maxProbableClass=0;
        finalClass=0;
        maxProbableClass=findKNearestPoints(test_data,testRow,k);
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
        %finalClass
        %maxProbableClass
    
        if (maxProbableClass==finalClass)
            accuracy=accuracy+1;
        end
    end
    %accuracy=(accuracy/testN)*100;
end


%start of program
[N,D] = size(train_data);
training_graph=zeros(4,4,4,3,3,3);
fieldValues=zeros(1,6);
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
    %x
    
    for f=1:D
        property=train_data(n,f);
        if (f==3 || f==4)
            fieldValues(1,f) = findNumber(f,property);
        else
            fieldValues(1,f) = findString(f,property);
        end
       % fieldValues(f)
    end
    if (fieldValues(1,1)~=-1 && fieldValues(1,2)~=-1 && fieldValues(1,3)~=-1 && fieldValues(1,4)~=-1 && fieldValues(1,5)~=-1 && fieldValues(1,6)~=-1)
        training_graph(fieldValues(1,1),fieldValues(1,2),fieldValues(1,3),fieldValues(1,4),fieldValues(1,5),fieldValues(1,6))=x;
    end
end
new_accu=findOutput( new_data, new_label, k);
train_accu=findOutput( train_data, train_label, k);
end