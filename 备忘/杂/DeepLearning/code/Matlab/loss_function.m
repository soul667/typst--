a=rand();
b=rand()*2+1;
theta=[0,0];
SampleSize=20; % number of samples
x=zeros(SampleSize,2);
y=zeros(SampleSize,1);

x(:,1)=linspace(-10,10,SampleSize);
x(:,2)=ones(SampleSize,1);
y=f(x,[a,b])+randn(SampleSize,1)*a*3;



% GdAns=gdescent(x,y,theta,0.01,1000);

Gdans=gdescent2D(x,y,theta,0.01,1000,SampleSize);
% ShowLossFunction(x,y);
function y = f(x,theta)
    y = x*theta';
end

function Cost = Cost(x,y,theta)
    SampleSize = size(x, 1);
    Cost = sum((f(x,theta)-y).^2)/(2*SampleSize);
end

function GdAns=gdescent2D(x,y,theta,alpha,iter,SampleSize)
    if nargin < 6
        SampleSize = size(x, 1);
    end
    for i=1:iter
        error=(f(x,theta)-y);
        dratio=0.01;
        for j =1:size(theta,2)
            ThetaUse = zeros(theta.size());
            ThetaUse(j) = dratio;
            theta(j) = theta(j) - alpha*sum((f(x,theta+ThetaUse)-f(x,theta-ThetaUse))/(2*dratio))/SampleSize;
        end
        % Cost = Cost(x,y,theta);
        % fprintf('Cost: %f\n',Cost);
    end
    GdAns = theta;
end

function ShowLossFunction(x,y)
    a = linspace(0,3,200);
    b = linspace(0,3,200);
    J = zeros(length(a),length(b));
    for i=1:length(a)
        for j=1:length(b)
            J(i,j) = Cost(x,y,[a(i),b(j)]);
        end
    end
    figure;
    surf(a,b,J);
end

% function Show
% 绘制等高线图
