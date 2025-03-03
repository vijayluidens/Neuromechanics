global model
% Plot stumbler outcome
figure(1)
set(1, 'units', 'normalized', 'position', [0.1 0.1 0.8 0.8])
h = axes;

% Lengths
Lstance     = model.Lstance;    % [m]
Lhip        = model.Lhip;       % [m]
Lthigh      = model.Lthigh;     % [m]
Lshank      = model.Lshank;     % [m]
Lfoot       = model.Lfoot;      % [m]

% Centres of gravity with respect to proximal joint
cgStance    = model.cgStance;   % [m]
cgThigh     = model.cgThigh;    % [m]
cgShank     = model.cgShank;    % [m]
cgFoot      = model.cgFoot;     % [m]

% Part B: Brick coordinates
bx1         = model.bx1;
bx2         = model.bx2;
by1         = model.by1;
by2         = model.by2;
bz1         = model.bz1;
bz2         = model.bz2;

%Definition of brick's vertices
vertices = [bz1, bx1, by1;
            bz1, bx2, by1;
            bz1, bx2, by2;
            bz1, bx1, by2;
            bz2, bx1, by1;
            bz2, bx2, by1;
            bz2, bx2, by2;
            bz2, bx1, by2];

%definition of brick's faces
brick_faces = [1, 2, 6, 5;
               2, 3, 7, 6;
               3, 4, 8, 7;
               4, 1, 5, 8;
               1, 2, 3, 4;
               5, 6, 7, 8];

for jj = [3, 1]
    for kk = 1:jj:length(X_out.time)
        % Get angles from the correct index of X_out.signals.values
        % Example gamma1 = X_out.signals.values(kk,1)

        gamma1 = X_out.signals.values(kk,1);
        alpha2 = X_out.signals.values(kk,2);
        beta2  = X_out.signals.values(kk,3);
        gamma2 = X_out.signals.values(kk,4);
        gamma3 = X_out.signals.values(kk,5);
        gamma4 = X_out.signals.values(kk,6);

        symb_Ti;
        % Mass locations (Hint; use values from Ti)
        xmass = Ti([4, 10, 16, 22]);
        ymass = Ti([5, 11, 17, 23]);
        zmass = Ti([6, 12, 18, 24]);

        % Joint locations (Hint; use values from Ti)
        xjoint = [0; Ti([1, 7, 13, 19, 25])];
        yjoint = [0; Ti([2, 8, 14, 20, 26])];
        zjoint = [0; Ti([3, 9, 15, 21, 27])];

        subplot(223) % Front view
        plot([0; Ti(3:3:end)], [0; Ti(2:3:end)], 'b-', 'linewidth', 2); hold on
        plot(zjoint, yjoint, 'bo', 'markerfacecolor', 'w');
        plot(zmass, ymass, 'ks', 'markerfacecolor', 'k');
        plot([-1 1], [0 0], 'k--'); hold off
        axis([-1 1 -0.1 1])
        title('Front view')
        
        subplot(221) % Top view
        plot([0; Ti(3:3:end)], [0; Ti(1:3:end)], 'b-', 'linewidth', 2); hold on
        plot(zjoint, xjoint, 'bo', 'markerfacecolor', 'w');
        plot(zmass, xmass, 'ks', 'markerfacecolor', 'k'); hold on
        patch('Vertices', vertices(:, 1:2), 'Faces', [1, 2, 3, 4; 3, 4, 8, 7; 4, 1, 5, 8; 5 6 7 8], ...
              'FaceColor', [0.6 0.3 0.1], 'FaceAlpha', 0.7, 'EdgeColor', 'k'); % Brick added
        hold off
        axis([-1 1 -1 1]);
        title('Top view')

        subplot(224) % Right view
        plot([0; Ti(1:3:end)],  [0; Ti(2:3:end)], 'b-', 'linewidth', 2); hold on
        plot(xjoint, yjoint, 'bo', 'markerfacecolor', 'w');
        plot(xmass, ymass, 'ks', 'markerfacecolor', 'k');
        plot([-1 1], [0 0], 'k--'); hold off
        axis([-1 1 -0.1 1])
        text(-0.9, 0.9, ['TIME: ', num2str(X_out.time(kk)), ' s.'])
        title('Right view')

        subplot(2,2,2) % 3D view
        plot3([0; Ti(3:3:end)], [0; Ti(1:3:end)], [0; Ti(2:3:end)], 'b-', 'linewidth', 2); hold on
        plot3(zjoint, xjoint, yjoint, 'bo', 'markerfacecolor', 'w');
        plot3(zmass, xmass, ymass, 'ks', 'markerfacecolor', 'k'); hold off
        axis([-1 1 -1 1 0 1])
        view([1 0.5 0.5])
        xlabel('z'); ylabel('x'); zlabel('y')
        grid on
        title('3D view')

        % Plot brick
        hold on
        patch('Vertices', vertices, 'Faces', brick_faces, ...
            'FaceColor', [0.6 0.3 0.1], 'FaceAlpha', 0.7, 'EdgeColor', 'k');

        hold off
        axis([-1 1 -1 1 0 1])
        view([1 0.5 0.5])
        xlabel('z'); ylabel('x'); zlabel('y')
        grid on
        title('3D view')

        drawnow

    end
    pause(0.5)
end
disp('END of animation')