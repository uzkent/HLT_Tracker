function [hist]=bgsample(ml,hist,tt,j,tm,Im_2)
%% ------------------------------------------------------------------------
% Explanation:
%           This function collects spectral data at the future path of the
%           track estimation. It considers a window proportional to the
%           speed of the track.
%% ------------------------------------------------------------------------
%% Track Statistics - Prior
mean=tt.x_predic{j};                            
edge_x=ceil(mean(1));
edge_y=ceil(mean(2));

%% Collect Spectral Data
cols=max(min(edge_x,573)-15,1):max(min(edge_x+15,573),1);
rows=max(min(edge_y,394)-15,1):max(min(edge_y+15,394),1);
rw = size(rows,2);
cl = size(cols,2);

hist.future_sp{j,tm}=Im_2.Image(rows,cols,:);  
test_data = reshape(hist.future_sp{j,tm},rw*cl,61);

%% Classify the Spectral Vectors - Grass, Vegetation, Shadow, Road (Asphalt)
[label,~,~] = svmpredict([ones(rw*cl,1)], test_data, ml.SVM,'-q');
label = reshape(label,size(rows,2),size(cols,2));

% % Perform Vegetation Dominated Pixel Classification using NDVI
% for rs = 1:rw 
%     for cs = 1:cl
%         if label(rs,cs) == -1       % Road
%             plot(cols(1)+cs-1,rows(1)+rs-1,'o','Linewidth',1,'MarkerEdgeColor','r','MarkerFaceColor','k','MarkerSize',2)
%         elseif label(rs,cs) == 0    % Vegetation
%             plot(cols(1)+cs-1,rows(1)+rs-1,'o','Linewidth',1,'MarkerEdgeColor','g','MarkerFaceColor','k','MarkerSize',2)
%         elseif label(rs,cs) == -2   % Shadow
%             plot(cols(1)+cs-1,rows(1)+rs-1,'o','Linewidth',1,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',2)
%         elseif label(rs,cs) == -3   % Grass
%             plot(cols(1)+cs-1,rows(1)+rs-1,'o','Linewidth',1,'MarkerEdgeColor','y','MarkerFaceColor','k','MarkerSize',2)
%         else
%             plot(cols(1)+cs-1,rows(1)+rs-1,'o','Linewidth',1,'MarkerEdgeColor','c','MarkerFaceColor','k','MarkerSize',2)
%         end
%     end
% end
