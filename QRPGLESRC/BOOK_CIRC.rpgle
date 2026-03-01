      **free
      //---------------------------------------------------------
      // Book Circulation Engine
      // Handles issuing and returning of books
      //---------------------------------------------------------
      ctl-opt dftactgrp(*no) actgrp(*new) option(*nodebugio);

      dcl-f BOOKS usage(*update) keyed;
      dcl-f MEMBERS usage(*input) keyed;

      dcl-pi MAIN;
        pBookID char(10);
        pMemID  char(10);
        pAction char(1); // 'I' for Issue, 'R' for Return
      end-pi;

      dcl-s errorMsg varchar(50);

      // Verify Member status
      chain pMemID RMEMB;

      if not %found(MEMBERS);
        errorMsg = 'Member ID Not Found: ' + pMemID;
        dsply errorMsg;
        return;
      elseif ACTIVE = 'N';
        errorMsg = 'Member ID ' + pMemID + ' is Inactive';
        dsply errorMsg;
        return;
      endif;

      // Perform circulation action
      chain pBookID RBOOK;

      if not %found(BOOKS);
        errorMsg = 'Book ID Not Found: ' + pBookID;
      else;
        if pAction = 'I'; // Issue
          if QTY > 0;
            QTY -= 1;
            if QTY = 0;
               STATUS = 'O'; // Out of stock
            endif;
            update RBOOK;
          else;
            errorMsg = 'No copies of ' + pBookID + ' are available';
          endif;
        elseif pAction = 'R'; // Return
          QTY += 1;
          STATUS = 'A'; // Now available
          update RBOOK;
        endif;
      endif;

      if errorMsg <> '';
        dsply errorMsg;
      endif;

      *inlr = *on;
