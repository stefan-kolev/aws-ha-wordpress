<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'dbname' );

/** MySQL database username */
define( 'DB_USER', 'dbuser' );

/** MySQL database password */
define( 'DB_PASSWORD', 'dbpass' );

/** MySQL hostname */
define( 'DB_HOST', 'dhhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '#I/p3%=QS *7du)pnQ7CfoCpoa*0FY6dkHz80i4X/F1d0(lNE5FSlNS-(jC@f&2n');
define('SECURE_AUTH_KEY',  '%^:Jqp-9V!?y1 ZfY<p?P9JP4I5-WU&#(?:6aC3fCsj$c2mPMzzGg[wg&ik+$A/6');
define('LOGGED_IN_KEY',    'K4rpw!<,1JP;K/D~IK#oiBYC2PYiKWn::OwAf(`UH2?#BD:!fvLc${GaNieE5gUN');
define('NONCE_KEY',        'Ki@#_!w{EPoZj]~6pn42:Mu-riCNsFT%p!U`, (oRUiQ[T3B$7o$;%LH{++;9R?|');
define('AUTH_SALT',        'J6?]52XSYD!<|-B!wS/!e9RPVpCLc5-Rzf(2/+|P+zF:$([A41u37s!-[F=*rvk?');
define('SECURE_AUTH_SALT', '/mxuQ=KRMA-_R41Izy;|^#!h8?qIm-UE!=w1SdFyL^,yB-F3O+)!iI*_lVu`RgLi');
define('LOGGED_IN_SALT',   '+#sAG+tv*;3O]9uH *iMAX8RUrg=)GfxGn4+%uLci)[ ]sA}vG.Rrt4#K7tR|w;#');
define('NONCE_SALT',       '$iDW|CsF0FyiY:-S=?q~RO:.FY[q*^C7NIn]AI&GUv+%{L)@cAwi-<o(TJJ~`R!S');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
