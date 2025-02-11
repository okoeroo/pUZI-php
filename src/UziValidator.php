<?php

namespace MinVWS\PUZI;

use MinVWS\PUZI\Exceptions\UziException;

/**
 * Class UziValidator
 * @package MinVWS\Laravel\Puzi
 */
class UziValidator
{
    /** @var bool */
    protected $strictCAcheck;
    /** @var array */
    protected $allowedTypes;
    /** @var array */
    protected $allowedRoles;

    /**
     * UziValidator constructor.
     *
     * @param bool $strictCaCheck
     * @param array $allowedTypes
     * @param array $allowedRoles
     */
    public function __construct(bool $strictCaCheck, array $allowedTypes, array $allowedRoles)
    {
        $this->strictCAcheck = $strictCaCheck;
        $this->allowedTypes = $allowedTypes;
        $this->allowedRoles = $allowedRoles;
    }

    /**
     * @param UziUser $user
     * @return bool
     */
    public function isValid(UziUser $user): bool
    {
        try {
            $this->validate($user);
        } catch (UziException $e) {
            return false;
        }
        return true;
    }

    /**
     * @param UziUser $user
     * @throws UziException
     */
    public function validate(UziUser $user): void
    {
        if (
            $this->strictCAcheck == true &&
            $user->getOidCa() !== UziConstants::OID_CA_CARE_PROVIDER &&
            $user->getOidCa() !== UziConstants::OID_CA_NAMED_EMPLOYEE
        ) {
            throw new UziException('CA OID not UZI register Care Provider or named employee');
        }
        if ($user->getUziVersion() !== '1') {
            throw new UziException('UZI version not 1');
        }
        if (!in_array($user->getCardType(), $this->allowedTypes)) {
            throw new UziException('UZI card type not allowed');
        }
        if (!in_array(substr($user->getRole(), 0, 3), $this->allowedRoles)) {
            throw new UziException("UZI card role not allowed");
        }
    }
}
