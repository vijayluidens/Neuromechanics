% Plot pendulum outcome
figure(1)
h = axes;

% x1 = X_out.signals.values(:,4); % Positions joint 1
% y1 = X_out.signals.values(:,5);
% z1 = X_out.signals.values(:,6);
% x2 = X_out.signals.values(:,7); % Positions mass 2
% y2 = X_out.signals.values(:,8);
% z2 = X_out.signals.values(:,9);
% x3 = X_out.signals.values(:,10); % Positions mass 3
% y3 = X_out.signals.values(:,11);
% z3 = X_out.signals.values(:,12);

x1 = X_out.signals.values(:,1); % Positions mass 1
y1 = X_out.signals.values(:,2);
z1 = X_out.signals.values(:,3);
x2 = X_out.signals.values(:,4); % Positions 1/2 mass 2
y2 = X_out.signals.values(:,5);
z2 = X_out.signals.values(:,6);
x3 = X_out.signals.values(:,7); % Positions 2/2 mass 2
y3 = X_out.signals.values(:,8);
z3 = X_out.signals.values(:,9);



xc = (x2 + x3) / 2; % Positions connection mass2 and mass 3 to segment 2;
yc = (y2 + y3) / 2;
zc = (z2 + z3) / 2;

for kk = 1:length(X_out.time)
    subplot(223) % Front view
    
    plot([0, x1(kk), xc(kk), x2(kk), xc(kk), x3(kk)], [0, z1(kk), zc(kk), z2(kk), zc(kk), z3(kk)], '.-')
    axis([-2 2 -2.5 0.1]);
    title('Front view')
    
    subplot(221) % Top view
    plot([0, x1(kk), xc(kk), x2(kk), xc(kk), x3(kk)], [0, y1(kk), yc(kk), y2(kk), yc(kk), y3(kk)], '.-')
    axis([-2 2 -2 2]);
    title('Top view')    
    
    subplot(224) % Right view
    plot([0, y1(kk), yc(kk), y2(kk), yc(kk), y3(kk)],  [0, z1(kk), zc(kk), z2(kk), zc(kk), z3(kk)], '.-')
    axis([-2 2 -2.5 0.1]);
    title('Right view')   
    
    subplot(2,2,2) % 3D view
    plot3([0, x1(kk), xc(kk), x2(kk), xc(kk), x3(kk)], [0, y1(kk), yc(kk), y2(kk), yc(kk), y3(kk)], [0, z1(kk), zc(kk), z2(kk), zc(kk), z3(kk)], '.-')
    hold on; plot3(x2(kk), y2(kk), -2.5, '.'); hold off
    axis([-2 2 -2 2 -2.5 0.1]);
    view([1 1 1])
    grid on
    title('3D view')
    drawnow
end
disp('END of animation')