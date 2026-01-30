-- ==========================================================
-- FIX KODE VARIAN - Generate consistent unique codes
-- Format: KV-[MASTER_ID]-[SEQ] (e.g., KV-001-01, KV-001-02)
-- ==========================================================

-- Step 1: Create temporary procedure to update kode_varian
DELIMITER $$

DROP PROCEDURE IF EXISTS update_kode_varian$$

CREATE PROCEDURE update_kode_varian()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_master_id INT;
    DECLARE v_seq INT DEFAULT 0;
    DECLARE v_prev_master INT DEFAULT 0;
    DECLARE v_new_code VARCHAR(20);
    
    -- Cursor to iterate through all variants ordered by master_id and id
    DECLARE cur CURSOR FOR 
        SELECT id, kaos_master_id 
        FROM kaos_varian 
        ORDER BY kaos_master_id, id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_id, v_master_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Reset sequence for new master
        IF v_master_id != v_prev_master THEN
            SET v_seq = 1;
            SET v_prev_master = v_master_id;
        ELSE
            SET v_seq = v_seq + 1;
        END IF;
        
        -- Generate new code: KV-001-01
        SET v_new_code = CONCAT('KV-', LPAD(v_master_id, 3, '0'), '-', LPAD(v_seq, 2, '0'));
        
        -- Update the record
        UPDATE kaos_varian SET kode_varian = v_new_code WHERE id = v_id;
        
    END LOOP;
    
    CLOSE cur;
END$$

DELIMITER ;

-- Step 2: Execute the procedure
CALL update_kode_varian();

-- Step 3: Clean up
DROP PROCEDURE IF EXISTS update_kode_varian;

-- Step 4: Verify the results
SELECT 
    km.id as master_id,
    km.nama_kaos,
    kv.kode_varian,
    kv.warna,
    kv.size
FROM kaos_varian kv
JOIN kaos_master km ON kv.kaos_master_id = km.id
ORDER BY km.id, kv.id
LIMIT 30;

-- DONE! Kode varian now follows format: KV-001-01, KV-001-02, etc.
