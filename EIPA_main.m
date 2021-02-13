set(0, 'DefaultFigureWindowStyle', 'Docked')

clc
clear
close all

% ELEC 4700 - PA5: Harmonic Waves
% Brandon Schelhaas
% 101036851

% Initialize Variables
nx = 50;
ny = 50;
V = zeros(nx, ny);
G = sparse(nx*nx,ny*ny);

% Boundary Conditions:
% Diagonal = 1, rest = 0

for row = 1:ny
    for col = 1:nx
        % Map the 2D region into a (length*width, 1) vector
        n = row + (col-1)*ny;
        nxm = row + (col-2)*ny;
        nxp = row + (col)*ny;
        nym = (row-1) + (col-1)*ny;
        nyp = (row+1) + (col-1)*ny;
        
        % Note: Note sure if this is correct, but its my best attempt, that
        % seems to "work"... no additional 
        %----------------------------------
        
        % Setup G matrix (equations to use on mapped field), based on FDM
        % Setup BC's (all to 1)
        if row == 1 | row == ny | col == 1 | col == nx
            G(n,n) = 1;
        else % from FDM
            G(n,n) = -4; % Central point
            G(n,nxp) = 1; % col + 1
            G(n,nxm) = 1; % col - 1
            G(n,nyp) = 1; % row + 1
            G(n,nym) = 1; % row - 1  
        end
        
        % Change the material / make the wave propagate faster/slower
        if (col > 10 & col < 20 & row > 10 & row < 20)
            G(n,n) = -2; 
        end
        
        %-------------------------------------
    end
end

% Following lines are referenced from Prof. Smy's code, for ease of
% understanding

% Plot G
figure
spy(G);
title('G Matrix');
xlabel('nx'); ylabel('ny');

% Solve numModes worth of eigenvectors and values
numModes = 9;
[E, D] = eigs(G, numModes, 'SM'); % E = eigenvectors, V = eigenvalues

% Plot eigenvalues
figure
plot(diag(D), '.');
title('Eigenvalues');

% Plot eigenvectors
for vector = 1:numModes
    vec = E(:,vector);
    for row = 1:ny
        for col = 1:nx
            n = col + (row-1)*nx; % Remap the vector back into 2D
            V(row,col) = vec(n);
        end
    end
    figure
    surf(V)
    title(['Eigenvector #', num2str(vector)]);
end