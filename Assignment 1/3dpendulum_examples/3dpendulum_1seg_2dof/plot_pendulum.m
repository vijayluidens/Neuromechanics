% Plot pendulum outcome
figure(1)
h = axes;

x = X_out.signals.values(:,1);
y = X_out.signals.values(:,2);
z = X_out.signals.values(:,3);

for kk = 1:length(X_out.time)
    subplot(223) % Front view
    plot([0, x(kk)], [0, z(kk)], '.-')
    axis([-1 1 -1.5 0.1]);
    title('Front view')
    
    subplot(221) % Top view
    plot([0, x(kk)], [0, y(kk)], '.-')
    axis([-1 1 -1 1]);
    title('Top view')    
    
    subplot(224) % Right view
    plot([0, y(kk)], [0, z(kk)], '.-')
    axis([-1 1 -1.5 0.1]);
    title('Right view')   
    
    subplot(2,2,2) % 3D view
    plot3([0, x(kk)], [0, y(kk)], [0, z(kk)], '.-')
    hold on; plot3(x(kk), y(kk), -1.5, '.'); hold off
    axis([-1 1 -1 1 -1.5 0.1]);
    view([1 1 1])
    grid on
    title('3D view')
    drawnow
end