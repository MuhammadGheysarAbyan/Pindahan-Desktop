SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE detail_transaksi;
TRUNCATE TABLE payment_proof;
TRUNCATE TABLE transaksi;
SET FOREIGN_KEY_CHECKS = 1;
SELECT 'Transaction history cleared' AS message;
